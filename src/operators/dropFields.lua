local Chain = require("chain_class")
local util = require("util")
local xtable = require("xtable")
local asserts = require("asserts")

--- For each table element in the chain, creates a new table excluding the specified fields.
--- If an element is array-table or not a table - it is passed through unchanged.
--- Numeric-keyed fields could not be dropped.
--- @param fieldsToDrop table A sequence table of string field names to drop.
--- @return Chain A new Chain where table elements have the specified fields removed.
function Chain:dropFields(fieldsToDrop)
    asserts.is_table(fieldsToDrop)
    local dropSet = {}
    for _, fName in ipairs(fieldsToDrop) do
        dropSet[fName] = true
    end
    local newXt = xtable.new()
    for _, nk, v in self._xt:trios() do
        if type(v) ~= "table" or util.isArray(v) then
            newXt:insert(nk, v)
        else
            local newValue = {}
            for ck, cv in pairs(v) do
                if not dropSet[ck] then
                    newValue[ck] = cv
                end
            end
            newXt:insert(nk, newValue)
        end
    end
    return Chain.new(newXt)
end
