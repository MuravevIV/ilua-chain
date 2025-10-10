local Chain = require("chain_class")

--- Chain constructor function
---@param source table|userdata|Chain|nil Source collection or Chain
---@return Chain
local function _chain(source)
    return setmetatable(source, {
        __call = function(_, coll)
            return Chain.new(coll)
        end
    })
end
