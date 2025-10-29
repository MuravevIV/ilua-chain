local Chain = require("chain_class")
local asserts = require("asserts")

--- Checks if all elements satisfy `pred(value, [key, index])`. True if empty.
--- @param pred function Function `function(value, [key, index])`.
--- @return boolean True if all elements satisfy (or chain is empty).
function Chain:all(pred)
    asserts.is_function(pred)
    return self._xt:all(pred)
end
