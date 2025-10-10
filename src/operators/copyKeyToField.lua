local Chain = require("chain_class")
local util = require("util")
local xtable = require("xtable")
local asserts = require("asserts")

--- Iterates underlying collection (expected map-like). For each entry,
--- if value is a table, copies original key to value-table under `fieldName`.
--- Replaces `fieldName` field if it exists for value-tables.
--- Returns new chain of these modified values as a map.
---
--- Example:
--- ```
--- local data = {
---   admin = {name = "Alice",   level = 10},
---   user  = {name = "Bob",     level = 5},
---   guest = {name = "Charlie", level = 1}
--- }
---
--- local result = chain(data):copyKeyToField("role"):toList()
---
--- result == {
---   admin = {name = "Alice",   level = 10, role = "admin"},
---   user  = {name = "Bob",     level = 5,  role = "user"},
---   guest = {name = "Charlie", level = 1,  role = "guest"}
--- }
--- ```
---
--- @param fieldName string Name of the field to store the original key.
--- @return Chain A new Chain where elements (if tables) have original key added, preserved as a map.
function Chain:copyKeyToField(fieldName)
    asserts.is_non_empty_string(fieldName)
    local newXt = xtable.new()
    for _, nk, v in self._xt:trios() do
        if type(v) == "table" then
            local newVal = util.shallowCopy(v)
            newVal[fieldName] = nk
            newXt:insert(nk, newVal)
        else
            newXt:insert(nk, v)
        end
    end
    return Chain.new(newXt)
end
