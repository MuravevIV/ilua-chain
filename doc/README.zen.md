
# ilua-chain

`ilua-chain` is a Lua table-wrapper that keeps positional information for elements -
even in cases when wrapped table is a `Map`.
- Preserves order of elements, similar to `List`
- Rich key context, similar to `Map`
- **Immutable**. All operations are producing new instances of a `chain`.

### Definitions

"index" / "position"
- "index" - numeric keys from 1 to N with no gaps, defining indexed part of the Lua's native `table`.
- "position" - refers to the `chain`'s internal position, assigned to elements

`List` - Duck-type, `table` where all keys belong to index; or an empty `table`; or List-like `userdata`.
- Preserves order of elements
- Poor key context (numeric sequence only)

`Map` - Duck-type, `table` with at least one key outside of the index; or an empty `table`; or Map-like `userdata`.
- Does not preserve order of elements
- Rich key context (anything)

`Collection` - Duck-type, either `List` or `Map`.

## Starting

```lua
local chain = require("chain")

local data = {a = 10, c = 30, b = 20}
local s = chain(data) -- wrapping the collection
    :filter(function(v) return v > 15 end) -- applying chainable operation(s)
    :map(function(v) return v * 2 end) -- each operation produces new `chain` instance
    -- etc...
local result = s:toMap() -- unwrapping chain back into a table 
assert(type(result) == "table") -- it's a table
```

## Elements access with `:get`, `:at` and `:val`

- `:get` - **get** element by-key
- `:at` - get element **at**-position
- `:val` - get element by-**val**ue (for reverse lookup)

```lua
local chain = require("chain")

local data = {a = 10, b = 20, c = 30}
local s = chain(data) -- ordering for elements is not guaranteed, since collection is a `Map`
s = s:orderByKey()     -- applying natural ordering by keys, note the re-assignment - because of the immutability

print(( s:get("a") )) -- > "10" -- double-parenthesis to only print the first value (see below)
print(( s:at(2)    )) -- > "20" -- guaranteed result, even for wrapped `Map`
print(( s:val(30)  )) -- > "30" -- reverse lookup explained below
```

All three: `:get`, `:at` and `:val` - return `nil` if element is not found.

All three: `:get`, `:at` and `:val` could return associated values of others, when assigned to a trio of variables:

```lua
local chain = require("chain")

local s = chain({a = 10, b = 20, c = 30}):orderByKey()

local function printTrio(v, nk, ik)
    print("Value " .. v .. ", by key '" .. nk .. "', at position " .. ik)
end

local v, nk, ik = s:get("a")
printTrio(v, nk, ik) -- > "Value 10, by key 'a', at position 1"

v, nk, ik = s:at(2)
printTrio(v, nk, ik) -- > "Value 20, by key 'b', at position 2"

v, nk, ik = s:val(30)
printTrio(v, nk, ik) -- > "Value 30, by key 'c', at position 3"
```

Position is preserved by the internal implementation, using an additional index.

## Iterating with `:trios`

```lua
for ik, nk, v in s:trios() do
    printTrio(v, nk, ik)
end
-- > "Value 10, by key 'a', at position 1"
-- > "Value 20, by key `b`, at position 2"
-- > "Value 30, by key `c`, at position 3"
```

`:trios`, similarly to `ipairs`, will always iterate through elements in-order, using element's position (`ik`).

Note that the assignment order of `ik, nk, v` variables for `:trios` is reversed -
to be compliant with `pairs` and `ipairs` implementation.

## Converting back to `table`

Conversion to the native Lua table could be done with either `:toList` or `:toMap`:
- `:toList` - keys **ARE NOT** preserved (reindexed by 1..N), but internal order **IS** guaranteed
- `:toMap`- keys **ARE** preserved, but internal order **IS NOT** guaranteed

```lua
local data = {a = 10, b = 20, c = 30}
local s = chain(data):orderByKey()

s:toList()
-- > { 10, 20, 30 } -- essentially: { [1] = 10, [2] = 20, [3] = 30 }

s:toMap()
-- > { b = 20, c = 30, a = 10 }
```

## Specifics of the `List`

When `chain` wraps a `List` - it automatically keeps the original order of the `List`.
I.e. `ik == nk`:

```lua
local data = {40, 60, 50}
local s = chain(data)

for ik, nk, v in s:trios() do
    printTrio(v, nk, ik)
end
-- > "Value 40, by key '1', at position 1"
-- > "Value 60, by key `2`, at position 2"
-- > "Value 50, by key `3`, at position 3"
```

However, as operations are applied - keys are not kept in sync with positions:

```lua
s = s:order() -- natural ordering by values

for ik, nk, v in s:trios() do
    printTrio(v, nk, ik)
end
-- > "Value 40, by key '1', at position 1"
-- > "Value 50, by key `3`, at position 2"
-- > "Value 60, by key `2`, at position 3"
```
