local Chain = require("chain_class")

--- Asserts that chain has at most `n` elements, throws assertion error if not. Returns `self`.
--- @param n number Maximum expected count.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertCountAtMost(n, msg)
    local cnt = self._xt:len()
    local m = msg or "Chain:assertCountAtMost failed: Expected count of at most " .. n .. "."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt <= n, ms)
    return self
end
