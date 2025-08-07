package = "lru-memoize"
version = "1.0.0-1"

source = {
	url = "",
	dir = ""
}

description = {
	summary = "LRU based memoization cache for Lua functions.",
	detailed = [[
	]],
	homepage = "https://github.com/piyuple/lru-memoize",
	license = "MIT"
}

build = {
	type = "builtin",
	modules = {
		["lru-memoize"] = "src/lrucache.lua"
	}
}

dependencies = {
	"lua >= 5.1"
}

test = {
	type = "command",
	command = "busted --verbose"
}
