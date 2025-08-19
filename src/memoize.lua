-- lru-memoize, LRU based memoization cache for Lua functions
-- Copyright (c) 2025 Piyush Ranjan
-- See the LICENSE file for terms of use.

---@class Memoizer
local Memoizer = {}
Memoizer.__index = Memoizer

Memoizer._VERSION = "1.0.0"

local lru = require("lru")

-- backwards compatibility
local unpack = table.unpack or unpack

---@package
local function _pack(...)
	local n = select("#", ...)
	local t = { n = n }

	for i = 1, n do
		t[i] = select(i, ...)
	end

	return t
end

---@package
local function _unpack(t)
	if not t then
		return nil
	end

	return unpack(t, 1, t.n)
end

---@param seed number
---@param capacity number
---@param byte_capacity number?
function Memoizer.new(seed, capacity, byte_capacity)
	assert(type(seed) == "number" and seed > 0, "seed must be positive number")
	assert(type(capacity) == "number" and capacity > 0, "capacity must be positive number")

	local cache = lru.new(capacity, byte_capacity)
	local memoizer = {}

	---@param fn function
	---@param opts {ttl: number, serializer: function, hasher: function} -- ttl: seconds
	function memoizer.memoize(fn, opts)
		assert(type(fn) == "function", "arg#1 to memoize must be a function")

		opts = opts or {}
		local ttl = opts.ttl
		local serializer = opts.serializer
			or function(args)
				local msgpack = require("cmsgpack")
				return msgpack.pack(args)
			end
		local hasher = opts.hasher
			or function(bytes)
				local hash = require("xxhash")
				return hash.xxh32(bytes, seed)
			end

		local function makeKeyFromArgs(...)
			local ok, packed = pcall(serializer, { ... })
			if not ok then
				error(packed)
			end

			return hasher(packed)
		end

		local function wrapper(...)
			local key = makeKeyFromArgs(...)

			local entry = cache:get(key)
			if entry then
				if entry.expires then
					-- when expired
					if os.time() >= entry.expires then
						cache:delete(key)
					else
						return _unpack(entry.result) -- hit
					end
				else
					-- no ttl set
					return _unpack(entry.result)
				end
			end

			-- miss
			local res = (function(...)
				return _pack(fn(...))
			end)(...)

			local storedEntry = { result = res }
			if ttl and type(ttl) == "number" then
				storedEntry.expires = os.time() + ttl
			end

			cache:set(key, storedEntry)

			return _unpack(res)
		end

		return wrapper
	end

	function memoizer.cache()
		return cache
	end

	return memoizer
end

return Memoizer
