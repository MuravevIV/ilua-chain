local Chain = require("chain_class")
local xtable = require("xtable")
local asserts = require("asserts")

---@class Chain
---@field _xt table The internal xtable representation.

--- Merges the key-value pairs from the current Chain into a copy of the target table.
--- For matching keys, the value from the current Chain overrides the target's value.
--- The original target table is not modified.
---@param target table The table to merge into (not modified).
---@return Chain A new Chain with the merged result.
function Chain:mergeByKeyInto(target)
    asserts.is_table(target)
    local newXt = xtable.new()
    for k, v in pairs(target) do
        newXt:insert(k, v)
    end
    for _, k, v in self._xt:trios() do
        newXt:insert(k, v)
    end
    return Chain.new(newXt)
end
