local Chain = require("chain_class")
local xtable = require("xtable")
local util = require("util")

--- Merges the key-value pairs from the current Chain into a copy of the target table.
--- For matching keys, the value from the current Chain overrides the target's value.
--- The original target table is not modified.
---@param target table|Chain The table to merge into (not modified).
---@return Chain A new Chain with the merged result.
function Chain:mergeByKeyInto(target)
    if type(target) ~= "table" then
        error("target must be a table or Chain instance")
    end
    local newXt = xtable.new()
    if util.isa(target, Chain) then
        for _, k, v in target._xt:trios() do
            newXt:insert(k, v)
        end
    else
        for k, v in pairs(target) do
            newXt:insert(k, v)
        end
    end
    for _, k, v in self._xt:trios() do
        newXt:insert(k, v)
    end
    return Chain.new(newXt)
end
