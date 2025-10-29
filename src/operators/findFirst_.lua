local Chain = require("chain_class")
local util = require("util")
local asserts = require("asserts")

--- Finds the first element satisfying `pred(value, [key, index])`, or returns `nil`.
--- @param pred function The predicate `function(value, [key, index])`.
--- @return any The first matching element as `value, [key, index]`, or `nil`.
function Chain:findFirstOrNil(pred)
    asserts.is_function(pred)
    return self._xt:find(pred)
end

--- Finds the first element satisfying `pred(value, [key, index])`, or returns `defaultVal`.
--- @param pred function The predicate `function(value, [key, index])`.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The first matching element as `value, [key, index]`, or `defaultVal`.
function Chain:findFirstOrElse(pred, dv, dk, di)
    asserts.is_function(pred)
    asserts.is_not_nil(dv)
    return util._orElse(dv, dk, di, self._xt.find, self._xt, pred)
end

--- Finds the first element satisfying `pred(value, [key, index])`, or throws an error.
--- @param pred function The predicate `function(value, [key, index])`.
--- @param msg? string Custom error message.
--- @return any The first matching element as `value, [key, index]`.
function Chain:findFirstOrError(pred, msg)
    asserts.is_function(pred)
    msg = msg or "findFirstOrError(..) failed: no element found by predicate"
    return util._orError(msg, self._xt.find, self._xt, pred)
end
