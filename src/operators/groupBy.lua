
local Chain = require("chain_class")
local xtable = require("xtable")
local asserts = require("asserts")

--- Groups elements based on a key extracted by `keyExtractor(v, k, i)`.
--- Returns a Chain with an ordered map of group entries. Each group entry has the form:
--- ```lua
--- groupKey = { <xtable of all elements sharing groupKey> }
--- ```
--- The order of first appearance of each group key is preserved.
---
--- Example:
--- ```lua
--- local data = {
---   { type = "admin", name = "Alice"   },
---   { type = "user",  name = "Bob"     },
---   { type = "admin", name = "Charlie" }
--- }
---
--- local grouped = chain(data)
---     :groupBy(function(v, k, i) return v.type end)
---     :toMap()
---
--- grouped == {
---   admin = {
---       {type = "admin", name = "Alice"},
---       {type = "admin", name = "Charlie"}
---   },
---   user = {
---       {type = "user", name = "Bob"}
---   }
--- }
--- ```
---
---@param keyExtractor function A function receiving (value, key, index) and returning the group key.
---@return Chain A new Chain of group entries.
function Chain:groupBy(keyExtractor)
    asserts.is_function(keyExtractor)
    local newXt = xtable.new()
    for i, k, v in self._xt:trios() do
        local groupKey = keyExtractor(v, k, i)
        if groupKey ~= nil then
            local groupXt = newXt:getByNKey(groupKey)
            if groupXt == nil then
                groupXt = xtable.new()
                newXt:insert(groupKey, groupXt)
            end
            local elem = groupXt:getByNKey(k)
            if elem == nil then
                groupXt:insert(k, v)
            end
        end
    end
    local finalXt = xtable.new()
    for _, groupKey, groupXt in newXt:trios() do
        finalXt:insert(groupKey, Chain.new(groupXt))
    end
    return Chain.new(finalXt)
end
