local Chain = require("chain_class")
local asserts = require("asserts")

--- Applies `actFn(value, key)` to each element for side-effects. Returns `self`.
--- @param actFn function `function(value, key)`.
--- @return Chain The current Chain object.
function Chain:forEach(actFn)
    asserts.is_function(actFn)
    self._xt:each(actFn)
    return self
end
