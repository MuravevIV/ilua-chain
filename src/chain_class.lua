local util = require("util")
local xtable = require("xtable")

---@class Chain
local Chain = {}
Chain.__index = Chain

--- Creates a new Chain from a source table or Chain
---@param source table|userdata|Chain Source collection or Chain
---@return Chain
function Chain.new(source)
    if util.isa(source, Chain) then
        return source
    end
    if xtable.isXTable(source) then
        return setmetatable({ _xt = source }, Chain)
    end
    local cType = type(source)
    if cType ~= "table" and cType ~= "userdata" then
        error("chain(..) expects a table, compatible userdata, or an existing Chain instance. Got type: " .. cType, 2)
    end
    local newXt = xtable.fromUPairs(source)
    return setmetatable({ _xt = newXt }, Chain)
end

--- Creates an empty Chain
---@return Chain
function Chain.empty()
    return setmetatable({ _xt = xtable.new() }, Chain)
end

--- Unwraps a Chain to its underlying collection
---@param source table|Chain Source collection or Chain
---@return table|nil
function Chain.unwrap(source)
    if util.isa(source, Chain) then
        return source:toMap()
    elseif type(source) == "table" then
        return source
    else
        return nil
    end
end

function Chain:__pairs()
    return self._xt:pairs()
end

return Chain
