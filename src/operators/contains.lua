local Chain = require("chain_class")

-- todo! specs
--- Checks if stream contains `el`.
--- @param el any Element to search for.
--- @return boolean True if found.
function Chain:contains(el)
    return self:any(function(v) return v == el end)
end