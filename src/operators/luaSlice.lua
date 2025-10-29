local Chain = require("chain_class")
local slice = require("slice")

function Chain:luaSlice(pStart, pEnd, pStep)
    return Chain.new(slice(self._xt, pStart, pEnd, pStep, 1))
end
