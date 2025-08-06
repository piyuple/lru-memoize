package = "lua_lru_cache"
version = "1.0.0-1"

source = {
	url = "",
	dir = ""
}

description = {
	summary = "LRU based memoization cache for Lua functions.",
	detailed = [[
	]],
	homepage = "https://github.com/piyuple/lua_lru_cache",
	license = "MIT"
}

build = {
	type = "builtin",
	modules = {
		["lua_lru_cache"] = "src/lrucache.lua"
	}
}

dependencies = {
	"lua >= 5.1"
}

test = {
	type = "command",
	command = "busted --verbose"
}
