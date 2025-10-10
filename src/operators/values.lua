local Chain = require("chain_class")
local xtable = require("xtable")

--- Returns new chain of all values from `pairs()` iteration. Order not guaranteed for maps.
--- @return Chain A new Chain object containing values.
function Chain:values()
    local newXt = xtable.new()
    for ik, _, v in self._xt:trios() do
        newXt:insert(ik, v)
    end
    return Chain.new(newXt)
end
