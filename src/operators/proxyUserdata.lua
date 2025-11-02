
local Chain = require("chain_class")
local xtable = require("xtable")

--- Iterates the underlying collection using `pairs()`. For each entry, if its value is userdata,
--- it rewraps that userdata. Non-userdata values are kept as is.
--- This method returns a NEW Chain whose underlying collection is a NEW MAP,
--- mapping original keys to their (potentially) rewrapped values.
--- This is useful when the Chain's source is a map whose values are userdata that need wrapping
--- before further processing like assigning new fields.
---@return Chain A new Chain whose `_xt` is a map of original keys to (rewrapped) values.
function Chain:proxyUserdata()
    local newXt = xtable.new()
    for _, k, v in self._xt:trios() do
        if type(v) == "userdata" then
            local wrapper = {}
            setmetatable(wrapper, {
                __index = function(tbl, key)
                    local wrapperVal = rawget(tbl, key)
                    if wrapperVal ~= nil then
                        return wrapperVal
                    end
                    return v[key]
                end,
                __newindex = function(tbl, key, val)
                    rawset(tbl, key, val)
                end,
                __len = function()
                    return #v
                end,
                __tostring = function()
                    return "[WrappedUserdata: " .. tostring(v) .. "]"
                end,
                __pairs = function()
                    return pairs(v)
                end,
                __ipairs = function()
                    return ipairs(v)
                end,
                __eq = function(a, b)
                    return a == v and b == v
                end,
                __lt = function(a, b)
                    return a < v and b < v
                end,
                __le = function(a, b)
                    return a <= v and b <= v
                end,
                __add = function(a, b)
                    return a + v and b + v
                end,
                __sub = function(a, b)
                    return a - v and b - v
                end,
                __mul = function(a, b)
                    return a * v and b * v
                end,
                __div = function(a, b)
                    return a / v and b / v
                end,
                __mod = function(a, b)
                    return a % v and b % v
                end,
                __pow = function(a, b)
                    return a ^ v and b ^ v
                end,
                __unm = function(a)
                    return -v
                end,
                __concat = function(a, b)
                    return a .. v and b .. v
                end,
                __call = function(tbl, ...)
                    return v(...)
                end
            })
            newXt:insert(k, wrapper)
        else
            newXt:insert(k, v)
        end
    end
    return Chain.new(newXt)
end
