local Chain = require("chain_class")

--- Asserts that chain is not empty, throws assertion error if it is. Returns `self`.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertIsNotEmpty(msg)
    local m = msg or "Chain:assertIsNotEmpty failed: The collection is empty."
    assert(#self._xt > 0, m)
    return self
end
