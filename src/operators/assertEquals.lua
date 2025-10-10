local Chain = require("chain_class")
local util = require("util")
local serpent = require("serpent")

-- todo! docs
function Chain:assertEquals(expected) -- todo! test
    local actual = self._xt:toMap()
    local isEquals = util.strict_eq(actual, expected)
    local expectedRepr = serpent.serialize(expected, {})
    local actualRepr = serpent.serialize(actual, {})
    if not isEquals then
        error("Not equal:\n\t\t\tExpected: " .. expectedRepr .. "\n\t\t\tActual:   " .. actualRepr, 2)
    end
    return self
end
