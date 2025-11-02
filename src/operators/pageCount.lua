local Chain = require("chain_class")
local asserts = require("asserts")

--- Calculates the total number of pages required to display all items in the chain,
--- given a number of items per page. This is a terminal operation.
--- @param itemsPerPage number integer - The number of items to display on each page.
--- @return number The total number of pages. Returns 0 if itemsPerPage <= 0 or chain is empty.
function Chain:pageCount(itemsPerPage)
    asserts.is_integer(itemsPerPage)
    if itemsPerPage <= 0 then
        return 0
    end
    local len = self._xt:len()
    if len == 0 then
        return 0
    end
    return math.ceil(len / itemsPerPage)
end
