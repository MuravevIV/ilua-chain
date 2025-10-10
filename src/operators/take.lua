local Chain = require("chain_class")
local asserts = require("asserts")

--- Takes first `n` elements, returns new chain.
--- @param n number Number of elements to take.
--- @return Chain A new Chain object.
function Chain:take(n)
    asserts.is_integer(n)
    return Chain.new(self._xt:take(n))
end
