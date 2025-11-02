local Chian = require("chain_class")
local xtable = require("xtable")

--- Removes all occurrences of `elToRem`, returning new chain.
---@param elToRem any Element to remove.
---@return Chain A new Chain object.
function Chain:remove(elToRem)
    local newXt = xtable.new()
    for _, k, v in self._xt:trios() do
        if v ~= elToRem then
            newXt:insert(k, v)
        end
    end
    return Chain.new(newXt)
end
