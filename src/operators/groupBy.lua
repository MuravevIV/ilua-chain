local Chain = require("chain_class")
local xtable = require("xtable")

--- Groups elements based on a key extracted by `keyExtractor(valueElement)`.
--- Returns a Chain with an ordered list of group entries. Each group entry has the form:
--- ```
--- { key = <groupKey>, value = <Chain of all elements sharing groupKey> }
--- ```
--- The order of first appearance of each group key is preserved.
---
--- Example:
--- ```
--- local data = {
---   {type = "admin", name = "Alice"},
---   {type = "user",  name = "Bob"},
---   {type = "admin", name = "Charlie"}
--- }
---
--- local grouped = chain(data)
---     :groupBy(function(valueElement)
---         return valueElement.type
---     end)
---     :toList()
---
--- grouped == {
---   { key = "admin", value = Chain{
---       {type = "admin", name = "Alice"},
---       {type = "admin", name = "Charlie"}
---   }},
---   { key = "user", value = Chain{
---       {type = "user", name = "Bob"}
---   }}
--- }
--- ```
---
--- @param keyExtractor function A function receiving an element and returning the group key.
--- @return Chain A new Chain of group entries.
function Chain:groupBy(keyExtractor)
    assert(type(keyExtractor) == "function", "Chain:groupBy: keyExtractor must be a function.")
    local newXt = xtable.new()
    for i, k, v in self._xt:trios() do
        local groupKey = keyExtractor(v, k, i)
        if groupKey ~= nil then
            local group = newXt:getByNKey(groupKey)
            if group == nil then
                newXt:insert(groupKey, {})
                group = newXt:getByNKey(groupKey)
            end
            table.insert(group, v)
        end
    end
    local finalXt = xtable.new()
    for _, groupKey, groupValues in newXt:trios() do
        finalXt:insert(groupKey, groupValues)
    end
    return Chain.new(finalXt)
end
