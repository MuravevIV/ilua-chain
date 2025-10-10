
```lua
local xtable = require("xtable")

-- `xtable` is a table-like structure with double-keys: indexed (iKey) and named (nKey)
-- iKey is always a numerical integer sequence with no gaps (index), nKey could be anything

local data = {
    [1]       = {name = "Alice",   level = 10},
    [2]       = {name = "Bob",     level = 5},
    [4]       = {name = "Charlie", level = 15},
    ["five"]  = {name = "David",   level = 25},
    ["admin"] = {name = "Edgar",   level = 80}
}

local uPairXTable = xtable.fromUPairs(data) -- iterate over `data` with just `pairs`
-- UPairs - means "potentially unordered pairs" (which they are)
-- uPairXTable == { -- order is not guaranteed to be like that
--     [1] = [1]       = {name = "Alice",   level = 10}, -- this double-keyed table format is pseudocode:
--     [2] = [2]       = {name = "Bob",     level = 5},  -- `[IKey] = [NKey] = Value`
--     [3] = [4]       = {name = "Charlie", level = 15},
--     [4] = ["five"]  = {name = "David",   level = 25},
--     [5] = ["admin"] = {name = "Edgar",   level = 80}
-- }

local oPairXTable = xtable.fromOPairs(data) -- iterate over `data` with special iterator implementation
-- OPairs - underlying iterator iterates over indexed keys first, then through hashed keys, ordered alphanumerically
-- oPairXTable == { -- now order is deterministic
--     [1] = [1]       = {name = "Alice",   level = 10},
--     [2] = [2]       = {name = "Bob",     level = 5},
--     [3] = [4]       = {name = "Charlie", level = 15},
--     [4] = ["admin"] = {name = "Edgar",   level = 80},
--     [5] = ["five"]  = {name = "David",   level = 25}
-- }

-- on ordering types "alphanumerically" - just need something that orders keys in a deterministic manner,
-- would prefer it to be sensible - hence alphanumerically. Suggest ordering function for all potential types?

-- xtable has a custom insert functionality:
local newXTable = xtable.new()
for k, v in pairs(data) do
    newXTable:insert(k, v) -- similar to `table.insert(someTable, value)`, but insertion comes with an nKey, while iKey is naturally incremented from 1
    -- if k already exist - `insert` upserts value to the existing (iKey, nKey)
end

-- xtable has a custom remove functionality, but only for nKey (method named to explicitly point on that)
-- elements are re-indexed by iKey
-- could it be more implementation-efficient if we'll have `removeAllByNKeys({ "multiple", "keys" })`?
local updXTable = newXTable:removeByNKey("admin")
-- updXTable == {
--     [1] = [1]       = {name = "Alice",   level = 10},
--     [2] = [2]       = {name = "Bob",     level = 5},
--     [3] = [4]       = {name = "Charlie", level = 15},
--     [4] = ["five"]  = {name = "David",   level = 25}
-- }

-- > How do you modify an existing element's value without changing its NKey or IKey? setByIKey(iKey, newValue), setByNKey(nKey, newValue).
-- `setByNKey` sounds about right; `setByIKey` - no, could break the sequence. 

-- xtable does not have __pairs or __ipairs, to not bring confusion
-- xtable has a custom "trios" iteration:
for iKey, nKey, value in oPairXTable:trios() do -- this iteration is always ordered by iKey, like `ipairs` for tables
    -- whatever
end

-- > Error Handling: What happens if getByIKey or getByNKey is called with a non-existent key? Return nil (idiomatic Lua) or error? (Nil is generally preferred).
-- Yes, it should return `nil`.

-- xtable has length operation (what's better: `count` or `length` or `len`?)
local cnt = oPairXTable:count()

-- custom function to extract original map-table:
local mapTable = oPairXTable:toMap()
-- mapTable == {
--     [1]       = {name = "Alice",   level = 10},
--     [2]       = {name = "Bob",     level = 5},
--     [4]       = {name = "Charlie", level = 15},
--     ["admin"] = {name = "Edgar",   level = 80},
--     ["five"]  = {name = "David",   level = 25}
-- }

-- custom function to extract ordered list-table:
local listTable = oPairXTable:toList()
-- listTable == {
--     [1] = {name = "Alice",   level = 10},
--     [2] = {name = "Bob",     level = 5},
--     [3] = {name = "Charlie", level = 15},
--     [4] = {name = "Edgar",   level = 80},
--     [5] = {name = "David",   level = 25}
-- }

-- custom function to get value by iKey
print(oPairXTable:getByIKey(4).name) -- "Edgar"

-- custom function to get value by nKey
print(oPairXTable:getByNKey(4).name) -- "Charlie"

```
