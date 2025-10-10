local Chain = require("chain_class")

--- Returns number of elements.
--- @return number Count of elements.
function Chain:count()
    return #self._xt
end
