local Chain = require("chain_class")
local util   = require("util")

--- Creates a map by taking each value-table element, using the value of `fieldName` as the new key,
--- and removes that field from the value-table in the resulting map.
--- Skips non-table elements, or table elements missing `fieldName`.
--- In case of duplicate keys, the first occurrence is preserved.
---
--- Example:
--- ```
--- local data = {
---   {role = "admin", name = "Alice"},
---   {role = "user",  name = "Bob"},
---   {role = "guest", name = "Charlie"}
--- }
---
--- local result = chain(data):moveFieldToKey("role"):toList()
---
--- result == {
---   admin = {name = "Alice"},
---   user  = {name = "Bob"},
---   guest = {name = "Charlie"}
--- }
--- ```
---
--- @param fieldName string The field whose value will become the map key.
--- @return Chain A new Chain containing a map, keyed by fieldName, without that field in each value.
function Chain:moveFieldToKey(fieldName)
    assert(type(fieldName) == "string" and #fieldName > 0,
            "Chain:moveFieldToKey: fieldName must be a non-empty string.")
    local newColl = {}
    for _, valueElement in self._xt:ipairs() do
        if type(valueElement) == "table" then
            local keyVal = valueElement[fieldName]
            if keyVal ~= nil and newColl[keyVal] == nil then
                local newValueElement = util.shallowCopy(valueElement)
                newValueElement[fieldName] = nil  -- remove the field from the new table
                newColl[keyVal] = newValueElement
            end
        end
    end
    return Chain.new(newColl)
end
