local Chain = require("chain_class")
local util = require("util")
local asserts = require("asserts")

--- Returns the last element as `value, [key, index]`, or `nil, [nil, nil]` if chain is empty.
--- @return any The last element as `value, [key, index]`, or `nil, [nil, nil]` if chain is empty.
function Chain:lastOrNil()
    return self._xt:last()
end

--- Returns the last element as `value, [key, index]`, or `dv, [dk, di]` if chain is empty.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The last element as `value, [key, index]`, or `dv, [dk, di]` if chain is empty.
function Chain:lastOrElse(dv, dk, di)
    asserts.if_present_then.is_integer(di)
    return util._orElse(dv, dk, di, self._xt.last, self._xt)
end

--- Returns the last element as `value, [key, index]`, or throws an error if the chain is empty.
--- @param msg string optional - Custom error message.
--- @return any The last element as `value, [key, index]`.
function Chain:lastOrError(msg)
    msg = tostring(msg or "lastOrError(..) failed: chain is empty") -- todo! make it all `tostring(..)`
    return util._orError(msg, self._xt.last, self._xt)
end
