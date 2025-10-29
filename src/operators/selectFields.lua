local Chain = require("chain_class")
local util = require("util")
local asserts = require("asserts")

--- For each table element in the chain, creates a new table containing only the specified fields.
--- If a specified field does not exist in an element, it's omitted in the new table.
--- If an element is array-table or not a table - it is passed through unchanged.
--- Numeric-keyed fields could not be selected.
--- @param fieldsToSelect table A sequence table of string field names to select.
--- @return Chain A new Chain where table elements have only the selected fields.
function Chain:selectFields(fieldsToSelect)
    asserts.is_table(fieldsToSelect)
    local coll = {}
    for _, element in self._xt:ipairs() do
        if type(element) ~= "table" or util.isArray(element) then
            table.insert(coll, element)
        else
            local newElement = {}
            for _, fieldName in ipairs(fieldsToSelect) do
                if type(fieldName) == "string" and element[fieldName] ~= nil then
                    newElement[fieldName] = element[fieldName]
                end
            end
            table.insert(coll, newElement)
        end
    end
    return Chain.new(coll)
end
