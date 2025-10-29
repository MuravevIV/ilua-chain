local Chain = require("chain_class")

--- Returns the underlying Lua collection as sequence. This is a terminal operation.
--- @return table The raw Lua collection as sequence.
function Chain:toList()
    return self._xt:toList()
end
