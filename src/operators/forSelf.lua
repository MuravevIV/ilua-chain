local Chain = require("chain_class")

-- todo! docs and tests
function Chain:forSelf(actFn)
    actFn(self)
    return self
end
