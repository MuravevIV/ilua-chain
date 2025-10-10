local Chain = require("chain_class")
local util = require("util")
local asserts = require("asserts")

--- For each table element in the chain, creates a new table with specified fields renamed.
--- Other fields are preserved.
--- If an element is array-table or not a table - it is passed through unchanged.
--- If an old field name in the renameMap does not exist in an element, it is ignored.
--- Numeric-keyed fields could not be renamed.
--- @param renameMap table A map where `key` is the old field name and `value` is the new field name.
---                        Example: `{ oldName = "newName", anotherOld = "anotherNew" }`
--- @return Chain A new Chain where table elements have specified fields renamed.
function Chain:renameFields(renameMap)
    asserts.is_table(renameMap)
    local newColl = {}
    for _, element in self._xt:ipairs() do
        if type(element) ~= "table" then
            table.insert(newColl, element)
        elseif util.isArray(element) then
            local newElement = {}
            for i = 1, #element do
                newElement[i] = element[i]
            end
            for k, v in pairs(element) do
                if type(k) == "string" then
                    local newKey = renameMap[k] or k
                    newElement[newKey] = v
                end
            end
            table.insert(newColl, newElement)
        else
            local newElement = {}
            for k, v in pairs(element) do
                if type(k) == "string" then
                    local newKey = renameMap[k] or k
                    newElement[newKey] = v
                else
                    newElement[k] = v
                end
            end
            table.insert(newColl, newElement)
        end
    end
    return Chain.new(newColl)
end
