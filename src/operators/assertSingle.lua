local Chain = require("chain_class")

--- Asserts that chain has exactly one element, throws assertion error if not. Returns `self`.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertSingle(msg)
    local cnt = self._xt:len()
    local m = msg or "Chain:assertSingle failed: Expected exactly one element."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt == 1, ms)
    return self
end
