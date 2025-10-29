
local Chain = require("chain_class")
local util = require("util")
local asserts = require("asserts")

local function buildJoinLkMap(strmInst, kExtFn)
    local lkMap = {}
    for i, k, v in strmInst._xt:trios() do
        local key = kExtFn(v, k, i)
        if lkMap[key] == nil then
            lkMap[key] = {}
        end
        table.insert(lkMap[key], v)
    end
    return lkMap
end

--- Inner join.
---@param rChain Chain The chain to join with.
---@param lKeyExtFn function function(leftValue, leftKey, leftIndex) to build a join key.
---@param rKeyExtFn function function(rightValue, rightKey, rightIndex) to build a join key.
---@param resSelFn function function(leftValue, rightValue) to build the result value.
---@return Chain New Chain with joined results.
function Chain:innerJoin(rChain, lKeyExtFn, rKeyExtFn, resSelFn)
    if not util.isa(rChain, Chain) then
        error("rChain must be a Chain instance", 2)
    end
    asserts.is_function(lKeyExtFn)
    asserts.is_function(rKeyExtFn)
    asserts.is_function(resSelFn)
    local resColl = {}
    local rLk = buildJoinLkMap(rChain, rKeyExtFn)
    for li, lk, lv in self._xt:trios() do
        local lKey = lKeyExtFn(lv, lk, li)
        if rLk[lKey] then
            for _, rv in ipairs(rLk[lKey]) do
                table.insert(resColl, resSelFn(lv, rv))
            end
        end
    end
    return Chain.new(resColl)
end

--- Left join.
---@param rChain Chain The chain to join with.
---@param lKeyExtFn function function(leftValue, leftKey, leftIndex) to build a join key.
---@param rKeyExtFn function function(rightValue, rightKey, rightIndex) to build a join key.
---@param resSelFn function function(leftValue, rightValue) to build the result value.
---@return Chain New Chain with joined results.
function Chain:leftJoin(rChain, lKeyExtFn, rKeyExtFn, resSelFn)
    if not util.isa(rChain, Chain) then
        error("rChain must be a Chain instance", 2)
    end
    asserts.is_function(lKeyExtFn)
    asserts.is_function(rKeyExtFn)
    asserts.is_function(resSelFn)
    local resColl = {}
    local rLk = buildJoinLkMap(rChain, rKeyExtFn)
    for li, lk, lv in self._xt:trios() do
        local lKey = lKeyExtFn(lv, lk, li)
        local matchREls = rLk[lKey]
        if matchREls then
            for _, rv in ipairs(matchREls) do
                table.insert(resColl, resSelFn(lv, rv))
            end
        else
            table.insert(resColl, resSelFn(lv, nil))
        end
    end
    return Chain.new(resColl)
end

--- Right join.
---@param rChain Chain The chain to join with.
---@param lKeyExtFn function function(leftValue, leftKey, leftIndex) to build a join key.
---@param rKeyExtFn function function(rightValue, rightKey, rightIndex) to build a join key.
---@param resSelFn function function(leftValue, rightValue) to build the result value.
---@return Chain New Chain with joined results.
function Chain:rightJoin(rChain, lKeyExtFn, rKeyExtFn, resSelFn)
    if not util.isa(rChain, Chain) then
        error("rChain must be a Chain instance", 2)
    end
    asserts.is_function(lKeyExtFn)
    asserts.is_function(rKeyExtFn)
    asserts.is_function(resSelFn)
    local resColl = {}
    local lLk = buildJoinLkMap(self, lKeyExtFn)
    for ri, rk, rv in rChain._xt:trios() do
        local rKey = rKeyExtFn(rv, rk, ri)
        local lMatches = lLk[rKey]
        if lMatches then
            for _, lv in ipairs(lMatches) do
                table.insert(resColl, resSelFn(lv, rv))
            end
        else
            table.insert(resColl, resSelFn(nil, rv))
        end
    end
    return Chain.new(resColl)
end

--- Outer join.
---@param rChain Chain The chain to join with.
---@param lKeyExtFn function function(leftValue, leftKey, leftIndex) to build a join key.
---@param rKeyExtFn function function(rightValue, rightKey, rightIndex) to build a join key.
---@param resSelFn function function(leftValue, rightValue) to build the result value.
---@return Chain New Chain with joined results.
function Chain:outerJoin(rChain, lKeyExtFn, rKeyExtFn, resSelFn)
    if not util.isa(rChain, Chain) then
        error("rChain must be a Chain instance", 2)
    end
    asserts.is_function(lKeyExtFn)
    asserts.is_function(rKeyExtFn)
    asserts.is_function(resSelFn)
    local resColl = {}
    local rLk = buildJoinLkMap(rChain, rKeyExtFn)
    local rElsMatched = {}
    for li, lk, lv in self._xt:trios() do
        local lKey = lKeyExtFn(lv, lk, li)
        local matchRElsKey = rLk[lKey]
        if matchRElsKey then
            for _, rv in ipairs(matchRElsKey) do
                table.insert(resColl, resSelFn(lv, rv))
                rElsMatched[rv] = true
            end
        else
            table.insert(resColl, resSelFn(lv, nil))
        end
    end
    for _, _, rv in rChain._xt:trios() do
        if not rElsMatched[rv] then
            table.insert(resColl, resSelFn(nil, rv))
        end
    end
    return Chain.new(resColl)
end
