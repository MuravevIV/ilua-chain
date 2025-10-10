local Chain = require("chain_class")
local xtable = require("xtable")

--- Sorts chain ascending, using natural order with stable sorting.
--- @return Chain A new Chain with sorted elements.
function Chain:order()
    local indexed = {}
    for idx, k, v in self._xt:trios() do
        table.insert(indexed, {idx = idx, k = k, v = v})
    end
    table.sort(indexed, function(a, b)
        if a.v == b.v then
            return a.idx < b.idx
        else
            return a.v < b.v
        end
    end)
    local newXt = xtable.new()
    for _, trio in ipairs(indexed) do
        newXt:insert(trio.k, trio.v)
    end
    return Chain.new(newXt)
end
