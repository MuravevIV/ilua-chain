local Chain = require("chain_class")
local xtable = require("xtable")
local asserts = require("asserts")

-- todo! rename to `mapKeyValueToFields`
--- Transforms a map-like collection into a sequence of tables with specified field names.
--- For each key-value pair in the collection, creates a new table with two fields:
--- one containing the key and one containing the value.
---
--- Example:
--- ```
--- local data = {
---   Alice   = 20,
---   Bob     = 25,
---   Charlie = 30
--- }
---
--- chain(data):mapEntryToFields("name", "age"):toList()
---
--- {
---   Alice   = { name = "Alice",   age = 20 },
---   Bob     = { name = "Bob",     age = 25 },
---   Charlie = { name = "Charlie", age = 30 }
--- }
--- ```
---
--- @param fieldKey string Field name to store the original key
--- @param fieldValue string Field name to store the original value
--- @return Chain A new Chain containing a sequence of tables with the specified fields
function Chain:mapEntryToFields(fieldKey, fieldValue) -- todo! rename
    asserts.is_non_empty_string(fieldKey)
    asserts.is_non_empty_string(fieldValue)
    local newXt = xtable.new()
    for _, nk, v in self._xt:trios() do
        newXt:insert(nk, {
            [fieldKey] = nk,
            [fieldValue] = v
        })
    end
    return Chain.new(newXt)
end
