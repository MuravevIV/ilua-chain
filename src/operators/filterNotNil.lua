local Chain = require("chain_class")

--- Filters out nil values from the chain.
---@return Chain A new Chain without nil elements.
function Chain:filterNotNil()
    return Chain.new(self._xt:filter(function(v)
        return v ~= nil
    end))
end
