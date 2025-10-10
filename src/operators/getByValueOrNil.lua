local Chain = require("chain_class")

-- todo! specs
function Chain:getByValueOrNil(key)
    return self._xt:getByValue(key)
end
