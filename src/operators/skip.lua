local Chain = require("chain_class")
local asserts = require("asserts")

--- Skips first `n` elements, returns new chain.
--- @param n number Number of elements to skip.
--- @return Chain A new Chain object.
function Chain:skip(n)
    asserts.is_integer(n)
    return Chain.new(self._xt:skip(n))
end
