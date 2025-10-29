
local Chain = require("chain_class")

--- Concatenates the string representations of the elements in the chain.
--- If no separator is provided, an empty string is used.
--- If a decorator function is provided, it is applied to each element before concatenation.
--- The decorator receives (value, key, index) and should return a string.
---
--- Example:
--- ```lua
--- local data = {"a", "b", "c"}
---
--- local result1 = chain(data):mkString(", ")
--- -- result1 == "a, b, c"
---
--- local decorator = function(v, k, i)
---     return i .. ":" .. v
--- end
--- local result2 = chain(data):mkString("; ", decorator)
--- -- result2 == "1:a; 2:b; 3:c"
--- ```
---
---@param separator string|nil The separator to use between elements (default: "").
---@param decorator function|nil The function to decorate each element (optional).
---@return string The concatenated string.
function Chain:mkString(separator, decorator)
    if separator == nil then
        separator = ""
    end
    return self._xt:reduce(function(acc, v, k, i)
        if decorator ~= nil then
            if acc == "" then
                return acc .. decorator(v, k, i)
            else
                return acc .. separator .. decorator(v, k, i)
            end
        else
            if acc == "" then
                return acc .. v
            else
                return acc .. separator .. v
            end
        end
    end, "")
end
