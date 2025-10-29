local Chain = require("chain_class")

-- todo! docs and tests
function Chain:mkString(separator, decorator)
    if separator == nil then
        separator = ""
    end
    return self._xt:reduce(function(acc, v, nk, ik)
        if decorator ~= nil then
            if acc == "" then
                return acc .. decorator(v, nk, ik)
            else
                return acc .. separator .. decorator(v, nk, ik)
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
