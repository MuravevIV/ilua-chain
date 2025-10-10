local Chain = require("chain_class")
local asserts = require("asserts")

--- Maps elements using mapping function, returning a new Chain.
--- @param mapper function The mapping function `function(value, [key, index])`.
--- @return Chain A new Chain containing mapped elements.
function Chain:map(mapper)
    asserts.is_function(mapper)
    return Chain.new(self._xt:map(mapper))
end
