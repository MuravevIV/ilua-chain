local Chain = require("chain_class")
local xtable = require("xtable")
local asserts = require("asserts")

--- Creates a map by taking each value-table element, using the value of `fieldName` as the new key.
--- Non-table elements are skipped. Table elements lacking `fieldName` are also skipped.
--- In case of duplicate keys, the first occurrence takes precedence.
---
--- Example:
--- ```
--- local data = {
---   {role = "admin", name = "Alice"},
---   {role = "user",  name = "Bob"},
---   {role = "guest", name = "Charlie"}
--- }
---
--- local result = chain(data):copyFieldToKey("role"):toList()
---
--- result == {
---   admin = {role = "admin", name = "Alice"},
---   user  = {role = "user",  name = "Bob"},
---   guest = {role = "guest", name = "Charlie"}
--- }
--- ```
---
--- @param fieldName string The field whose value will become the new map key
--- @return Chain A new Chain containing a map keyed by the specified field
function Chain:copyFieldToKey(fieldName)
    asserts.is_non_empty_string(fieldName)
    local newXt = xtable.new()
    for _, _, v in self._xt:trios() do
        if type(v) == "table" then
            local keyVal = v[fieldName]
            if keyVal ~= nil and newXt:getByNKey(keyVal) == nil then
                newXt:insert(keyVal, v)
            end
        end
    end
    return Chain.new(newXt)
end
