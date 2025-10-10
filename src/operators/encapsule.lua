local Chain = require("chain_class")

-- todo! docs and tests
function Chain:encapsule()
    return Chain.new(self._xt:map(function(v, k, idx)
        return  { [k] = v }, idx
    end))
end
