local Chain = require("chain_class")
local asserts = require("asserts")

--- Reduces chain elements to a single value using `reducer(accumulator, value)`.
--- Note: will return `nil` if executed on an empty collection with no `initVal`.
--- @param reducer function The reducing function `function(accumulator, value)`.
--- @param initValue any optional - Initial accumulator value.
--- @return any The reduced value.
function Chain:reduce(reducer, initValue)
    asserts.is_function(reducer)
    return self._xt:reduce(reducer, initValue)
end
