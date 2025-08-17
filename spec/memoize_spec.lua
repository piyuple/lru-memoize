-- lru-memoize, LRU based memoization cache for Lua functions
-- Copyright (c) 2025 Piyush Ranjan
-- See the LICENSE file for terms of use.

local say = require("say")
local property = require("spec.hasproperty")
assert:register("assertion", "property", property, "assertion.property.positive", "assertion.property.negative")

describe("lru-memoize", function()
	it("loads 'memoize' module", function()
		require("memoize")
	end)

	it("creates a memoizer", function()
		local lrumemoize = require("memoize")

		local _seed = 0xfff111
		local _capacity = 10
		local memoizer = lrumemoize.new(_seed, _capacity, nil)

		assert.has.property(memoizer, "cache", "function")
		assert.has.property(memoizer, "memoize", "function")
	end)

	it("memoizes a function", function()
		local memoizer = require("memoize").new(0xfff111, 10)
		local function fib(n)
			if n == 0 or n == 1 then
				return n
			end

			return fib(n - 1) + fib(n - 2)
		end

		local _s = os.time()
		local _res1 = fib(30)
		local _t1 = os.time() - _s

		fib = memoizer.memoize(fib)

		_s = os.time()
		local _res2 = fib(30)
		local _t2 = os.time() - _s

		assert.is_equal(_res1, _res2)
		assert.is_true(_t1 > _t2)
	end)

	it("memoizes with ttl on entry", function()
		local memoizer = require("memoize").new(0xfff111, 2)

		local _g = 10
		local ttl = 2
		local func = memoizer.memoize(function(x)
			return x + _g
		end, { ttl = ttl })

		local _res1 = func(2)
		assert.is_equal(_res1, _g + 2)

		_g = 15
		local _res2 = func(2)
		assert.is_not_equal(_res2, _g + 2)
		assert.is_equal(_res2, _res1)

		os.execute("sleep " .. ttl)

		_res2 = func(2)
		assert.is_equal(_res2, _g + 2)
		assert.is_not_equal(_res2, _res1)
	end)

	it("inspect the cache", function()
		local seed = 0xfff111
		local hasher = function(...)
			return require("xxhash").xxh32(
				(function(...)
					return require("cmsgpack").pack({ ... })
				end)(...),
				seed
			)
		end

		local memoizer = require("memoize").new(seed, 2)
		local func = memoizer.memoize(function(x)
			return x * 10
		end)

		local _arg1, _arg2 = 10, 20
		local _ans1, _ans2 = 100, 200
		local _res1, _res2 = func(_arg1), func(_arg2)
		local _hash1, _hash2 = hasher(_arg1), hasher(_arg2)

		assert.is_equal(_res1, _ans1)
		assert.is_equal(_res2, _ans2)

		local cache = memoizer.cache()
		assert.is_equal(cache:get(_hash1).result[1], _ans1)
		assert.is_equal(cache:get(_hash2).result[1], _ans2)
	end)
end)
