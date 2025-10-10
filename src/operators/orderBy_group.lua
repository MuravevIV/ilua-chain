local Chain = require("chain_class")
local xtable = require("xtable")
local asserts = require("asserts")

-- Builds a stable, multi-criterion comparison for ascending/descending.
-- Each entry in self._sortFunctions is { selector=<fn>, direction="asc"|"desc" }.
local function stableMultiCompare(sortFunctions)
    return function(a, b)
        for _, criteria in ipairs(sortFunctions) do
            local left = criteria.selector(a.value)
            local right = criteria.selector(b.value)

            if left < right then
                return criteria.direction == "asc"
            elseif left > right then
                return criteria.direction == "desc"
            end
            -- If equal, fall through to next criterion
        end
        -- All criteria equal, preserve original order
        return a.index < b.index
    end
end

local function performStableSort(chain)
    local indexed = {}
    for i, v in chain._xt:ipairs() do
        table.insert(indexed, { value = v, index = i })
    end
    table.sort(indexed, stableMultiCompare(chain._sortFunctions))

    local newXt = xtable.new()
    for _, item in ipairs(indexed) do
        newXt:insert(item.index, item.value)
    end
    local newChain = Chain.new(newXt)
    newChain._sortFunctions = chain._sortFunctions
    return newChain
end

--- Sorts chain ascending, using `selector(value)` for sort key with stable sorting.
--- @param selector function Function `function(value)` to extract sort key.
--- @return Chain A new Chain with sorted elements.
function Chain:orderBy(selector)
    asserts.is_function(selector)
    -- Reset sort functions, begin new chain
    self._sortFunctions = {
        { selector = selector, direction = "asc" }
    }
    return performStableSort(self)
end

--- Sorts chain descending, using `selector(value)` for sort key with stable sorting.
--- @param selector function Function `function(value)` to extract sort key.
--- @return Chain A new Chain with sorted elements.
function Chain:orderByDesc(selector)
    asserts.is_function(selector)
    -- Reset sort functions, begin new chain
    self._sortFunctions = {
        { selector = selector, direction = "desc" }
    }
    return performStableSort(self)
end

--- Adds an ascending sort criterion, preserving earlier criteria via stable sorting.
--- Sorts chain ascending, using `selector(value)` for the additional sort key.
--- @param selector function Function `function(value)` to extract sort key.
--- @return Chain The same Chain instance, re-sorted with the new criterion.
function Chain:thenBy(selector)
    asserts.is_function(selector)
    if not self._sortFunctions then
        error("Cannot call thenBy(..) without calling orderBy(..) or orderByDesc(..) first.")
    end
    table.insert(self._sortFunctions, { selector = selector, direction = "asc" })
    return performStableSort(self)
end

--- Adds a descending sort criterion, preserving earlier criteria via stable sorting.
--- Sorts chain descending, using `selector(value)` for the additional sort key.
--- @param selector function Function `function(value)` to extract sort key.
--- @return Chain The same Chain instance, re-sorted with the new criterion.
function Chain:thenByDesc(selector)
    asserts.is_function(selector)
    if not self._sortFunctions then
        error("Cannot call thenByDesc(..) without calling orderBy(..) or orderByDesc(..) first.")
    end
    table.insert(self._sortFunctions, { selector = selector, direction = "desc" })
    return performStableSort(self)
end
