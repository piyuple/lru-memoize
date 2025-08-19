# lru-memoize

[![Build](https://github.com/piyuple/lru-memoize/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/piyuple/lru-memoize/actions/workflows/build.yml)
[![Coverage Status](https://coveralls.io/repos/github/piyuple/lru-memoize/badge.svg?branch=main)](https://coveralls.io/github/piyuple/lru-memoize?branch=main)

### LRU based memoization cache for Lua functions

#### Install:

```
$ luarocks install lru-memoize
```

#### Usage:

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
local function calculate(a, b, c, d, s)
    return string.format("%s: %d", s, (a ^ b * c + d.v))
end

calculate = memoizer.memoize(calculate, { ttl = 60 })

print(calculate(2, 3, 4, { v = 5.5 }, "result")) -- function params cached for 60s
```

#### Dependencies:

- [lua-cmsgpack](https://github.com/antirez/lua-cmsgpack)
- [lua-lru](https://github.com/starius/lua-lru)
- [xxhash](https://github.com/mah0x211/lua-xxhash)

#### Notes:

The default serializer and hasher are `cmsgpack` and `xxhash`, respectively. If you can't install those C-based implementations with Lua bindings (for example when using a LuaJIT-based distribution such as LÖVE, etc.), you can swap them out for any custom or pre-existing pure-Lua implementations. Example:
```lua
local memoizer = require('lrumemoize').new(0xffffff, 10)

---@param n number
local function fibonacci(n)
    if n == 0 or n == 1 then
        return n
    end

    return fibonacci(n - 1) + fibonacci(n - 2)
end


local custom_serializer = require(...)
local custom_hasher = require(...)

fibonacci = memoizer.memoize(fibonacci, {
    serializer = custom_serializer,
    hasher = custom_hasher
})
```

The `lua-lru` implementation is pure-Lua and can be copied and used as-is.
