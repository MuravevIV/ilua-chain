-- chain.lua
--
-- An eager, functional, and immutable collection library.
-- It unifies list-like and dictionary-like tables into a single 'Chain' type.

local Chain = {}
Chain.__index = Chain

--- Creates a new, immutable Chain instance and its internal key map.
-- This is an internal constructor used by the public-facing factory functions.
-- @arg entries (table) A numerically indexed array of `{i, k, v}` triplets.
-- @returns (table) A new Chain instance.
local function new_chain(entries)
    local key_map = {}
    for i, entry in ipairs(entries) do
        key_map[entry.k] = i
    end
    return setmetatable({ _entries = entries, _key_map = key_map }, Chain)
end

--- Retrieves an element by its key using a hash map for O(1) lookup.
-- @arg key (*) The key of the element to find.
-- @returns (any, any, number) The value, key, and index of the found element, or nil.
function Chain:get(key)
    local index = self._key_map[key]
    if index then
        local entry = self._entries[index]
        return entry.v, entry.k, index
    end
    return nil
end

--- Retrieves an element by its 1-based index.
-- @arg index (number) The 1-based index of the element to retrieve.
-- @returns (any, any, number) The value, key, and index of the found element, or nil.
function Chain:at(index)
    local entry = self._entries[index]
    if entry then
        return entry.v, entry.k, index
    end
    return nil
end

--- Retrieves the first element found that matches the given value.
-- @arg value (*) The value of the element to find.
-- @returns (any, any, number) The value, key, and index of the found element, or nil.
function Chain:val(value)
    for i, entry in ipairs(self._entries) do
        if entry.v == value then
            return entry.v, entry.k, i
        end
    end
    return nil
end

--- Collapses the collection into a single value.
-- @arg reducer (function) The function to apply: `function(accumulator, value, key, index)`.
-- @arg initial (*) The initial value for the accumulator.
-- @returns (any) The final accumulated value.
function Chain:reduce(reducer, initial)
    local acc = initial
    for i, entry in ipairs(self._entries) do
        acc = reducer(acc, entry.v, entry.k, i)
    end
    return acc
end

--- Extracts a range of elements into a new Chain.
-- The range is inclusive. The original Chain is not modified.
-- @arg first (number) The starting 1-based index.
-- @arg last (number, OPTIONAL) The ending 1-based index. Defaults to the end of the collection.
-- @returns (table) A new Chain instance containing the sliced elements.
function Chain:slice(first, last)
    last = last or #self._entries
    local new_entries = {}
    for i = first, last do
        local entry = self._entries[i]
        if entry then
            table.insert(new_entries, { i = #new_entries + 1, k = entry.k, v = entry.v })
        end
    end
    return new_chain(new_entries)
end

--- Creates a new Chain with elements sorted by the given comparator.
-- The original Chain is not modified.
-- @arg comparator (function, OPTIONAL) A function `(a, b)` that returns true if element `a` should come before element `b`. Compares values by default.
-- @returns (table) A new, sorted Chain instance.
function Chain:sorted(comparator)
    local sorted_entries = {}
    for _, entry in ipairs(self._entries) do
        table.insert(sorted_entries, { k = entry.k, v = entry.v })
    end

    local compare_fn
    if comparator then
        compare_fn = function(a, b) return comparator(a.v, b.v) end
    else
        compare_fn = function(a, b) return a.v < b.v end
    end

    table.sort(sorted_entries, compare_fn)

    for i, entry in ipairs(sorted_entries) do
        entry.i = i
    end

    return new_chain(sorted_entries)
end

--- Creates a new Chain by merging this Chain with another.
-- The resulting Chain contains pairs ` {v1, v2} `, where `v1` is from this Chain and `v2` is from the other.
-- The new Chain's length is the minimum of the two source Chains' lengths.
-- @arg other (table) Another Chain instance to zip with.
-- @returns (table) A new Chain instance of paired values.
function Chain:zip(other)
    local new_entries = {}
    local len = math.min(#self._entries, #other._entries)
    for i = 1, len do
        local entry1 = self._entries[i]
        local entry2 = other._entries[i]
        table.insert(new_entries, { i = i, k = entry1.k, v = { entry1.v, entry2.v } })
    end
    return new_chain(new_entries)
end

--- Creates a new Chain with the same elements in a random order.
-- The original Chain is not modified.
-- @returns (table) A new, shuffled Chain instance.
function Chain:shuffled()
    local shuffled_entries = {}
    for _, entry in ipairs(self._entries) do
        table.insert(shuffled_entries, { k = entry.k, v = entry.v })
    end

    -- Fisher-Yates shuffle
    for i = #shuffled_entries, 2, -1 do
        local j = math.random(i)
        shuffled_entries[i], shuffled_entries[j] = shuffled_entries[j], shuffled_entries[i]
    end

    for i, entry in ipairs(shuffled_entries) do
        entry.i = i
    end

    return new_chain(shuffled_entries)
end

--- Converts the Chain back to a list-like table (array).
-- The order of the Chain is preserved. Keys are discarded.
-- @returns (table) A new list-like table.
function Chain:toList()
    local list = {}
    for _, entry in ipairs(self._entries) do
        table.insert(list, entry.v)
    end
    return list
end

--- Converts the Chain back to a dictionary-like table.
-- The order of the Chain is lost in the conversion.
-- @returns (table) A new dictionary-like table.
function Chain:toDict()
    local dict = {}
    for _, entry in ipairs(self._entries) do
        dict[entry.k] = entry.v
    end
    return dict
end

--- Returns the number of elements in the collection.
-- Allows the `#` operator to be used on a Chain instance.
function Chain:__len()
    return #self._entries
end

--- Provides a string representation of the Chain for printing.
function Chain:__tostring()
    local parts = {}
    for i, entry in ipairs(self._entries) do
        table.insert(parts, string.format("[%d] %s = %s", i, tostring(entry.k), tostring(entry.v)))
    end
    return "Chain {\n  " .. table.concat(parts, ",\n  ") .. "\n}"
end

-- Module table that will be returned by `require`.
local chain_module = {}

--- Creates a Chain from a list of key-value pairs.
-- The order of the pairs determines the Chain's internal order.
-- @arg pairs (table) A list of `{k1, v1, k2, v2, ...}`.
-- @returns (table) A new Chain instance.
function chain_module.fromPairs(pairs)
    local entries = {}
    for i = 1, #pairs, 2 do
        local k = pairs[i]
        local v = pairs[i + 1]
        table.insert(entries, { i = #entries + 1, k = k, v = v })
    end
    return new_chain(entries)
end

--- Main factory function to create a Chain from a Lua table.
-- @arg t (table) The source List-like or Dict-like table.
-- @returns (table) A new Chain instance.
local function create(t)
    local keys = {}
    local is_list = true
    local max_idx = 0

    for k in pairs(t) do
        table.insert(keys, k)
        if not (type(k) == "number" and k > 0 and k % 1 == 0) then
            is_list = false
        else
            max_idx = math.max(max_idx, k)
        end
    end

    if is_list and max_idx == #keys then
        -- It's a contiguous, 1-based list-like table. Preserve order.
        table.sort(keys)
    else
        -- It's a dict. Sort keys with specific precedence.
        table.sort(keys, function(a, b)
            local type_a, type_b = type(a), type(b)
            if type_a == "number" and type_b ~= "number" then return true end
            if type_a ~= "number" and type_b == "number" then return false end
            return a < b
        end)
    end

    local entries = {}
    for i, k in ipairs(keys) do
        table.insert(entries, { i = i, k = k, v = t[k] })
    end
    return new_chain(entries)
end

-- Make the module table callable like a function: `chain({...})`
setmetatable(chain_module, { __call = function(_, t) return create(t) end })

return chain_module
