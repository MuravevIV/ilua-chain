local Chain = require("chain_class")
local util = require("util")
local asserts = require("asserts")

--- Returns the first element, or `nil` if the chain is empty.
--- @return any The first element as `value, [key, index]`, or `nil`.
function Chain:firstOrNil()
    return self._xt:first()
end

--- Returns the first element, or `defaultVal` if the chain is empty.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The first element as `value, [key, index]`, or `dv, [dk, di]` if chain is empty.
function Chain:firstOrElse(dv, dk, di)
    asserts.if_present_then.is_integer(di)
    return util._orElse(dv, dk, di, self._xt.first, self._xt)
end

--- Finds the first element, or throws an error if the chain is empty.
--- @param msg string optional - Custom error message.
--- @return any The first element as `value, [key, index]`.
function Chain:firstOrError(msg)
    msg = msg or "firstOrError(..) failed: chain is empty"
    return util._orError(msg, self._xt.first, self._xt)
end
