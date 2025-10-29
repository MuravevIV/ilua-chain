local Chain = require("chain_class")

--- Checks if the chain is not empty.
--- @return boolean True if the chain contains one or more elements.
function Chain:isNotEmpty()
    return #self._xt > 0
end
