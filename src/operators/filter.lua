local Chain = require("chain_class")
local asserts = require("asserts")

--- Filters the elements of the chain based on a predicate function, returning a new Chain.
--- @param pred function The predicate `function(value, [key, index])`.
--- @return Chain A new Chain containing filtered elements.
function Chain:filter(pred)
    asserts.is_function(pred)
    return Chain.new(self._xt:filter(pred))
end
