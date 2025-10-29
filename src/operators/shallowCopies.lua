local Chain = require("chain_class")
local util = require("util")

--- Maps underlying value-tables to shallow copies of themselves.
--- Non-table values are preserved as-is.
--- @return Chain A new Chain object with shallow copies of values that are tables.
function Chain:shallowCopies()
    return Chain.new(self._xt:map(function(v)
        return util.shallowCopy(v)
    end))
end
