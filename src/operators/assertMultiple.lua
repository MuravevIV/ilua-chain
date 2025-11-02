
local Chain = require("chain_class")

--- Asserts that chain has more than one element, throws assertion error if not. Returns `self`.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertMultiple(msg)
    local cnt = self._xt:len()
    local m = msg or "Chain:assertMultiple failed: Expected more than one element."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt > 1, ms)
    return self
end
