# lru-memoize

[![Build](https://github.com/piyuple/lru-memoize/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/piyuple/lru-memoize/actions/workflows/build.yml)
[![Coverage Status](https://coveralls.io/repos/github/piyuple/lru-memoize/badge.svg?branch=main)](https://coveralls.io/github/piyuple/lru-memoize?branch=main)

LRU based memoization cache for Lua functions.

Install:

```
$ luarocks install lru-memoize
```

Usage:

```lua
local lrumemoize = require 'lrumemoize'

local seed = 0xff123
local capacity = 10
local memoizer = lrumemoize.new(seed, capacity)

---@param a number
---@param b number
---@param c number
---@param d { v: number }
---@param s string
local function calculate(a, b, c, d, e)
    return string.format("%s: %d", s, (a ^ b * c + d.v))
end

calculate = memoizer.memoize(calculate, opts = { ttl = 60 })

print(calculate(2, 3, 4, "result")) -- function params cached for 60s
```
