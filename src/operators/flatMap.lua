local Chain = require("chain_class")
local xtable = require("xtable")
local asserts = require("asserts")

--- Maps elements using `mapper(value, key)` to tables, then flattens results.
--- If `mapper` function returns not-table or nil - the entry is skipped.
--- If `keyMapper` function is missing - the operation does not preserve key information (produces sequence).
--- If `keyMapper` function is present - it's result is used as new keys for flattened entries.
--- If `keyMapper` returns nil - the entry is skipped.
--- In case of duplicate keys returned by `keyMapper` - the first occurrence takes precedence.
--- @param mapper function Function `function(value, key)` expected to return a table or nil.
--- @param keyMapper function optional - Function `function(parentValue, parentKey, parentIndex, childValue, childKey, childIndex)` expected to return a string or nil.
--- @return Chain A new Chain object with flattened elements.
function Chain:flatMap(mapper, keyMapper) -- todo! more unit tests
    asserts.is_function(mapper)
    asserts.if_present_then.is_function(keyMapper)
    local idx = 0
    local newXt = xtable.new()
    for pIK, pNK, pV in self._xt:trios() do
        local mapRes = mapper(pV, pNK, pIK)
        if type(mapRes) == "table" then
            for cNK, cV in pairs(mapRes) do
                idx = idx + 1
                if keyMapper ~= nil then
                    local newKey = keyMapper(pV, pNK, pIK, cV, cNK, idx)
                    if newKey ~= nil then
                        newXt:insert(newKey, cV)
                    end
                else
                    newXt:insert(idx, cV)
                end
            end
        end
    end
    return Chain.new(newXt)
end
