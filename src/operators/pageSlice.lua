local Chain = require("chain_class")
local slice = require("slice")
local asserts = require("asserts")

--- Returns a new chain containing the elements for a specific page.
--- Pages are 1-based.
--- @param itemsPerPage number integer - The number of items per page.
--- @param pageNum number integer - The 1-based page number to retrieve.
--- @return Chain A new Chain containing items for the specified page.
---                Returns an empty chain if pageNum is out of bounds or itemsPerPage <= 0.
function Chain:pageSlice(itemsPerPage, pageNum)
    asserts.is_integer(itemsPerPage)
    asserts.is_integer(pageNum)
    if itemsPerPage <= 0 or pageNum <= 0 then
        return Chain.empty()
    end
    local pStart = (pageNum - 1) * itemsPerPage + 1
    local pEnd = pageNum * itemsPerPage
    return Chain.new(slice(self._xt, pStart, pEnd, 1, 1))
end
