local chain = require("chain")
local xtable = require("xtable")

--- Creates a Chain from a sequence of key-value pairs
---@param ps any[] Sequence of alternating keys and values
---@return Chain
function chain.fromPairs(ps)
    local newXt = xtable.new()
    local key
    local isValue = false
    for _, it in ipairs(ps) do
        if isValue then
            newXt:insert(key, it)
        else
            key = it
        end
        isValue = not isValue
    end
    return Chain.new(newXt)
end
