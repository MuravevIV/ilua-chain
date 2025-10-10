local Chain = require("chain_class")

--- Returns new chain with distinct elements, preserving first-occurrence order.
--- Distinctiveness by identity (reference for tables, value for primitives).
--- @return Chain A new Chain object with distinct elements.
function Chain:distinct()
    return Chain.new(self._xt:distinct())
end
