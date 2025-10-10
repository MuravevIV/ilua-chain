local Chain = require("chain_class")

--- Applies `actFn(value, key)` to each element for side-effects. Returns `self`.
--- @param actFn function `function(value, key)`.
--- @return Chain The current Chain object.
function Chain:forEach(actFn)
    assert(type(actFn) == "function", "Chain:forEach: actFn must be a function.")
    self._xt:each(actFn)
    return self
end
