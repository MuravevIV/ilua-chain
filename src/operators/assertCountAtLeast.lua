local Chain = require("chain_class")

--- Asserts that chain has at least `n` elements, throws assertion error if not. Returns `self`.
--- @param n number Minimum expected count.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertCountAtLeast(n, msg)
    local cnt = self._xt:len()
    local m = msg or "Chain:assertCountAtLeast failed: Expected count of at least " .. n .. "."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt >= n, ms)
    return self
end
