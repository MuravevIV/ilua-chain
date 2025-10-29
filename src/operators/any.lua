local Chain = require("chain_class")
local asserts = require("asserts")

--- Checks if any element satisfies `pred(value, [key, index])`.
--- @param pred function optional - Function `function(value, [key, index])`.
--- @return boolean True if any element satisfies the predicate, False otherwise. If predicate is missing - returns True if chain contains at least one element, False otherwise.
function Chain:any(pred)
    asserts.is_function_or_nil(pred)
    return self._xt:any(pred)
end
