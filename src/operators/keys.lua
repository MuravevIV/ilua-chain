local Chain = require("chain_class")
local xtable = require("xtable")

--- Returns new chain of all keys from a chain.
--- @return Chain A new Chain object containing keys.
function Chain:keys()
    local newXt = xtable.new()
    for ik, nk, _ in self._xt:trios() do
        newXt:insert(ik, nk)
    end
    return Chain.new(newXt)
end
