local Chain = require("chain_class")

function Chain:getByKeyOrNil(key)
    return self._xt:getByNKey(key)
end
