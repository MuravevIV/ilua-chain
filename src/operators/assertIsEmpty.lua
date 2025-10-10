local Chain = require("chain_class")

--- Asserts that chain is empty, throws assertion error if it is not. Returns `self`.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertIsEmpty(msg)
    local cnt = #self._xt
    local m = msg or "Chain:assertIsEmpty failed: The collection is not empty."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt == 0, ms)
    return self
end
