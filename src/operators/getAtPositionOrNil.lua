local Chain = require("chain_class")

function Chain:getAtPositionOrNil(key)
    return self._xt:getByIKey(key) -- todo! specs
end
