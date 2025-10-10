local Chain = require("chain_class")
local chain = require("chain")
local xtable = require("xtable")
local asserts = require("asserts")

--- Generates a Chain of numbers in a range
---@param startNum number Starting number (inclusive)
---@param finishNum number Ending number (inclusive)
---@param stepNum? number Step value (default 1)
---@return Chain
function chain.range(startNum, finishNum, stepNum)
    asserts.is_integer(startNum)
    asserts.is_integer(finishNum)
    asserts.if_present_then.is_integer(stepNum)
    asserts.if_present_then.is_not_zero(stepNum)
    local step = stepNum or 1
    local newXt = xtable.new()
    local idx = 1
    for i = startNum, finishNum, step do
        newXt:insert(idx, i)
        idx = idx + 1
    end
    return Chain.new(newXt)
end
