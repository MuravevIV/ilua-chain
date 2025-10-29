local Chain = require("chain_class")

--- Returns the underlying Lua collection as map. This is a terminal operation.
--- @return table The raw Lua collection as map.
function Chain:toMap()
    return self._xt:toMap()
end
