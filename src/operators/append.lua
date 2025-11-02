
local Chain = require("chain_class")
local xtable = require("xtable")

--- Appends an element at the end of the chain, returning a new chain.
--- If `key` is provided, uses that explicit key (may overwrite if exists).
--- If no `key`, finds the maximum integer key (if any) and appends with max + 1.
--- If no integer keys and no explicit key, appends with key 1.
--- For maps without integer keys, this adds a numeric key, creating a mixed table (unless explicit key provided).
---@param el any Element to append.
---@param key any|nil Optional explicit key to use.
---@return Chain A new Chain object.
function Chain:append(el, key)
    local newXt = xtable.new()
    local maxKey = 0
    for _, k, v in self._xt:trios() do
        newXt:insert(k, v)
        if type(k) == "number" and math.floor(k) == k and k > maxKey then
            maxKey = k
        end
    end
    local appendKey
    if key ~= nil then
        appendKey = key
    else
        appendKey = maxKey + 1
    end
    newXt:insert(appendKey, el)
    return Chain.new(newXt)
end
