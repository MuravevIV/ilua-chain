local Chain = require("chain_class")
local util = require("util")
local asserts = require("asserts")

--- Iterates underlying collection (expected map-like). For each entry,
--- if value is a table, adds original key to value-table under `fieldName`.
--- Returns new chain of these modified values as a sequence.
---
--- Example:
--- ```
--- local data = {
---   admin = {name = "Alice",   level = 10},
---   user  = {name = "Bob",     level = 5},
---   guest = {name = "Charlie", level = 1}
--- }
---
--- local result = chain(data):moveKeyToField("role"):toList()
---
--- result == {
---   {name = "Alice",   level = 10, role = "admin"},
---   {name = "Bob",     level = 5,  role = "user"},
---   {name = "Charlie", level = 1,  role = "guest"}
--- }
--- ```
---
--- @param fieldName string Name of the field to store the original key.
--- @return Chain A new Chain where elements (if tables) have original key added, transformed to a sequence.
function Chain:moveKeyToField(fieldName)
    asserts.is_non_empty_string(fieldName)
    local newColl = {}
    for key, valueElement in pairs(self) do
        if type(valueElement) == "table" then
            local newValueElement = util.shallowCopy(valueElement)
            newValueElement[fieldName] = key
            table.insert(newColl, newValueElement)
        else
            table.insert(newColl, valueElement)
        end
    end
    return Chain.new(newColl)
end
