local Chain = require("chain_class")

--- Checks if the chain is empty.
--- @return boolean True if the chain contains no elements.
function Chain:isEmpty()
    return self._xt:len() == 0
end
