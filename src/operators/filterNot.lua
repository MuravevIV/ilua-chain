local Chain = require("chain_class")
local asserts = require("asserts")

--- Filters the elements of the chain based on an inverse of a predicate function.
--- The predicate function receives `(value, [key, index])`.
--- @param pred function The inverse filtering function `function(value, [key, index])`.
--- @return Chain A new Chain object containing the filtered elements.
function Chain:filterNot(pred)
    asserts.is_function(pred)
    return Chain.new(self._xt:filter(function(...)
        return not pred(...)
    end))
end
