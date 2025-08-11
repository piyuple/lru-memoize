rockspec_format = "1.0"
package = "lru-memoize"
version = "1.0.0-1"

source = {
	url = "git://github.com/piyuple/lru-memoize.git",
	tag = "v1.0.0",
}

description = {
	summary = "LRU based memoization cache for Lua functions",
	detailed = [[Lightweight memoization cache for Lua.
	Wraps functions to cache results using an LRU eviction policy and optional per-entry TTL for automatic expiration.
	Configurable capacity, optional key serializer and simple API for manual caching.
	]],
	homepage = "https://github.com/piyuple/lru-memoize",
	license = "MIT",
}

dependencies = {
	"lua >= 5.1",
	"lua-cmsgpack >= 0.4.0",
	"lua-lru >= 1.0",
	"xxhash >= 1.0",
}

build = {
	type = "builtin",
	modules = {
		["lrumemoize"] = "src/memoize.lua",
	},
}
