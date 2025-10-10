local Chain = require("chain_class")
local util = require("util")
local asserts = require("asserts")

--- Finds the last element satisfying `pred(value, key)`, or returns `nil`.
--- @param pred function The predicate `function(value, key)`.
--- @return any The last matching element, or `nil`.
function Chain:findLastOrNil(pred)
    asserts.is_function(pred)
    return self._xt:findLast(pred)
end

--- Finds the last element satisfying `pred(value, [key, index])`, or returns default value/key/index.
--- @param pred function The predicate `function(value, [key, index])`.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The last matching element as `value, [key, index]`, or `dv, [dk, di]` if last matching element is not found.
function Chain:findLastOrElse(pred, dv, dk, di)
    asserts.is_function(pred)
    asserts.if_present_then.is_integer(di)
    return util._orElse(dv, dk, di, self._xt.findLast, self._xt, pred)
end

--- Finds the last element satisfying `pred(value, [key, index])`, or throws an error.
--- @param pred function The predicate `function(value, [key, index])`.
--- @param msg string optional - Custom error message.
--- @return any The last matching element as `value, [key, index]`.
function Chain:findLastOrError(pred, msg)
    asserts.is_function(pred)
    msg = msg or "findLastOrError(..) failed: no element found by predicate"
    return util._orError(msg, self._xt.findLast, self._xt, pred)
end
