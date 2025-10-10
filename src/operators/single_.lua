local Chain = require("chain_class")
local util = require("util")
local asserts = require("asserts")

--- Returns the element if chain has one element, or `nil` if zero or more than one elements.
--- @return any The single element, or `nil`.
function Chain:singleOrNil()
    return self._xt:single()
end

--- Returns the single element as `value, [key, index]`, or `dv, [dk, di]` if zero or more than one elements.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The single element as `value, [key, index]`, or `dv, [dk, di]` if zero or more than one elements.
function Chain:singleOrElse(dv, dk, di)
    asserts.if_present_then.is_integer(di)
    return util._orElse(dv, dk, di, self._xt.single, self._xt)
end

--- Returns the single element as `value, [key, index]`, or throws an error if zero or more than one elements.
--- @param msg string optional - Custom error message.
--- @return any The single element as `value, [key, index]`.
function Chain:singleOrError(msg)
    local cnt = #self._xt
    local m = msg or "singleOrError failed: Expected single element."
    local ms = string.format("%s (Found %d elements)", m, cnt)
    return util._orError(ms, self._xt.single, self._xt)
end
