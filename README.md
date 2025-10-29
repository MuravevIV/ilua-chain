ilua-chain [![Build Status](https://travis-ci.org/MuravevIV/ilua-chain.svg)](https://travis-ci.org/MuravevIV/ilua-chain) [![Coverage Status](https://coveralls.io/repos/github/MuravevIV/ilua-chain/badge.svg?branch=master)](https://coveralls.io/github/MuravevIV/ilua-chain?branch=master)
===

Collection Extensions for Lua.

Main feature: deterministic ordering while working with map-like tables. 

## Zen

- Eager: it's easier to reason about than lazy
- Functional: it's more concise than imperative
- Chainable: it's just looks neat
- Ordered / Stable: wherever it's possible or makes sense
- Immutable: by giving the tools but not restricting mutability
- Predictable: no errors except argument assertions and explicitly-named operations
- Well-documented: documentation complements tests
- 100% test coverage: thanks, GenAI

```lua
local chain = require("chain")

local heroes = {
    Harry   = { age = 32, sex = "m" },
    Henry   = { age = 28, sex = "m" },
    James   = { age = 29, sex = "m" },
    Heather = { age = 17, sex = "f" }
}

local heroesWithStatus = chain(heroes)             -- wrapping collection into a `chain`
    :filter(function(p) return p.sex == "m" end)   -- filtering
    :assertIsNotEmpty("Error: no male heroes!")    -- asserting (will not throw on this data)
    :orderBy(function(p) return p.age end)         -- ordering
    :thenBy(function(p, name) return name end)     -- still ordering, second sorting condition
    :take(1)                                       -- slicing
    :shallowCopies()                               -- protecting from modifications (next operation)
    :each(function(p) p.status = "Chosen" end)     -- modifying (on a shallow copy)
    :mergeByKeyInto(heroes)                        -- merge (non-modifiable) into original map
    :toMap()                                       -- termination, returning Lua's map-table

-- heroes table is not modified
-- heroesWithStatus ==
{
    Harry   = { age = 32, sex = "m" },
    Henry   = { age = 28, sex = "m", status = "Chosen" },
    James   = { age = 29, sex = "m" },
    Heather = { age = 17, sex = "f" }
}
```

Getting Started
---

### Lua

Copy the `chain.lua` file into your project and require it:

```lua
local chain = require("chain")
```

You can also install ilua-chain using luarocks (mind the GitHub URL):

```sh
luarocks install https://raw.githubusercontent.com/MuravevIV/ilua-chain/master/rockspec/ilua-chain-0.0.1-1.rockspec
```

```lua
local chain = require("ilua.chain")
```

See [examples](examples) for more.

Resources
---

- [Documentation](doc)
- [Contributor Guide](doc/CONTRIBUTING.md)

Tests
---

Uses [lust](https://github.com/bjornbytes/lust). Run with:

```
lua tests/runner.lua
```

or, to run a specific test:

```
lua tests/runner.lua skipUntil
```

License
---

MIT, see [`LICENSE`](LICENSE) for details.
