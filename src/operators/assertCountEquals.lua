local Chain = require("chain_class")

--- Asserts that chain has exactly `n` elements, throws assertion error if not. Returns `self`.
--- @param n number Expected count.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertCountEquals(n, msg)
    local cnt = #self._xt
    local m = msg or "Chain:assertCountEquals failed: Expected count of " .. n .. "."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt == n, ms)
    return self
end
