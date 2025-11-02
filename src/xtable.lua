-- local serpent = require("serpent")

local xtable = {}
xtable.__index = xtable

function xtable.new()
    local self = setmetatable({}, xtable)
    self._nodes = {}
    self._nKey_to_iKey = {}
    return self
end

function xtable:insert(k, v)
    local existing_iKey = self._nKey_to_iKey[k]
    if existing_iKey ~= nil then
        self._nodes[existing_iKey].value = v
        return existing_iKey
    end
    local new_iKey = #self._nodes + 1
    self._nodes[new_iKey] = { nKey = k, value = v }
    self._nKey_to_iKey[k] = new_iKey
    return new_iKey
end

function xtable:insertValue(v)
    local existing_iKey = self._nKey_to_iKey[k]
    if existing_iKey then
        self._nodes[existing_iKey].value = v
        return existing_iKey
    end
    local new_iKey = #self._nodes + 1
    self._nodes[new_iKey] = { nKey = k, value = v }
    self._nKey_to_iKey[k] = new_iKey
    return new_iKey
end

function xtable:getByIKey(iKey)
    local node = self._nodes[iKey]
    if node then
        return node.value, node.nKey, iKey
    end
end

function xtable:getByNKey(nKey)
    local iKey = self._nKey_to_iKey[nKey]
    if iKey then
        local node = self._nodes[iKey]
        if node then
            return node.value, nKey, iKey
        end
    end
end

function xtable:getIKeyByNKey(nKey)
    return self._nKey_to_iKey[nKey]
end

function xtable:getNKeyByIKey(iKey)
    local node = self._nodes[iKey]
    if node then
        return node.nKey
    end
end

function xtable:setByIKey(iKey, newValue)
    local node = self._nodes[iKey]
    if node then
        node.value = newValue
        return true
    end
    return false
end

function xtable:setByNKey(nKey, newValue)
    local iKey = self._nKey_to_iKey[nKey]
    if iKey then
        return self:setByIKey(iKey, newValue)
    end
    return false
end

function xtable:removeByNKey(nKey)
    local iKey_to_remove = self._nKey_to_iKey[nKey]
    if not iKey_to_remove then
        return
    end
    local removed_node_wrapper = table.remove(self._nodes, iKey_to_remove)
    self._nKey_to_iKey[nKey] = nil
    for i = iKey_to_remove, #self._nodes do
        self._nKey_to_iKey[self._nodes[i].nKey] = i
    end
    return removed_node_wrapper.value
end

function xtable:removeAllByNKeys(nKeys_list)
    if not nKeys_list or #nKeys_list == 0 then return {} end
    local remove_set = {}
    for _, nKey in ipairs(nKeys_list) do
        if self._nKey_to_iKey[nKey] then remove_set[nKey] = true end
    end
    if next(remove_set) == nil then return {} end

    local new_nodes = {}
    local removed_values_map = {}
    local new_iKey_idx = 0
    for old_iKey = 1, #self._nodes do
        local node = self._nodes[old_iKey]
        if remove_set[node.nKey] then
            removed_values_map[node.nKey] = node.value
            self._nKey_to_iKey[node.nKey] = nil
        else
            new_iKey_idx = new_iKey_idx + 1
            new_nodes[new_iKey_idx] = node
            self._nKey_to_iKey[node.nKey] = new_iKey_idx
        end
    end
    self._nodes = new_nodes
    return removed_values_map
end

function xtable:len()
    return #self._nodes
end
xtable.__len = xtable.len
xtable.count = xtable.len

function xtable:trios()
    local current_iKey = 0
    local num_nodes = #self._nodes
    return function()
        current_iKey = current_iKey + 1
        if current_iKey <= num_nodes then
            local node = self._nodes[current_iKey]
            if node then
                return current_iKey, node.nKey, node.value
            end
        end
    end
end

function xtable:triosReversed()
    local current_iKey = #self._nodes + 1
    return function()
        current_iKey = current_iKey - 1
        if current_iKey >= 1 then
            local node = self._nodes[current_iKey]
            if node then
                return current_iKey, node.nKey, node.value
            end
        end
    end
end

function xtable:pairs()
    local current_iKey = 0
    local num_nodes = #self._nodes
    return function()
        current_iKey = current_iKey + 1
        if current_iKey <= num_nodes then
            local node = self._nodes[current_iKey]
            if node then
                return node.nKey, node.value
            end
        end
    end
end

function xtable:ipairs()
    local current_iKey = 0
    local num_nodes = #self._nodes
    return function()
        current_iKey = current_iKey + 1
        if current_iKey <= num_nodes then
            local node = self._nodes[current_iKey]
            if node then
                return current_iKey, node.value
            end
        end
    end
end

function xtable:toList()
    local list = {}
    for i = 1, #self._nodes do
        list[i] = self._nodes[i].value
    end
    return list
end

function xtable:toMap()
    local map = {}
    for i = 1, #self._nodes do
        local node = self._nodes[i]
        map[node.nKey] = node.value
    end
    return map
end

function xtable:clear()
    self._nodes = {}
    self._nKey_to_iKey = {}
end

function xtable:hasNKey(nKey)
    return self._nKey_to_iKey[nKey] ~= nil
end

function xtable:hasIKey(iKey)
    return type(iKey) == "number" and iKey >= 1 and iKey <= #self._nodes
end

local serpentSort = function(k, o, n)
    -- k=keys, o=originaltable, n=padding
    local maxn, to = tonumber(n) or 12, { number = 'a', string = 'b' }
    local function padnum(d)
        return ("%0" .. tostring(maxn) .. "d"):format(tonumber(d))
    end
    table.sort(k, function(a, b)
        -- sort numeric keys first: k[key] is not nil for numerical keys
        return (k[a] ~= nil and 0 or to[type(a)] or 'z') .. (tostring(a):gsub("%d+", padnum))
                < (k[b] ~= nil and 0 or to[type(b)] or 'z') .. (tostring(b):gsub("%d+", padnum))
    end)
end

function xtable.fromUPairs(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end
    serpentSort(keys)
    local newXt = xtable.new()
    for _, k in ipairs(keys) do
        newXt:insert(k, tbl[k])
    end
    return newXt
end

local TYPE_ORDER_MAP = {
    number = 1, string = 2, boolean = 3, table = 4,
    ["function"] = 5, userdata = 6, thread = 7, ["nil"] = 8
}

local function opairs_key_comparator(key1, key2)
    local type1, type2 = type(key1), type(key2)
    if type1 == type2 then
        if type1 == "number" or type1 == "string" then return key1 < key2
        elseif type1 == "boolean" then return not key1 and key2
        else return tostring(key1) < tostring(key2) end
    else
        return TYPE_ORDER_MAP[type1] < TYPE_ORDER_MAP[type2]
    end
end

function xtable.fromOPairs(data_table)
    local new_xt = xtable.new()
    if not data_table then return new_xt end
    local keys_list = {}
    for k_orig in pairs(data_table) do
        table.insert(keys_list, k_orig)
    end
    table.sort(keys_list, opairs_key_comparator)
    for _, sorted_key in ipairs(keys_list) do
        new_xt:insert(sorted_key, data_table[sorted_key])
    end
    return new_xt
end

function xtable.isXTable(obj)
    if type(obj) ~= "table" then
        return false
    end
    local mt = getmetatable(obj)
    if not mt then
        return false
    end
    return mt.__index == xtable
end

function xtable:map(mapper)
    local newXt = xtable.new()
        for i, k, v in self:trios() do
            local rs = { mapper(v, k, i) }
            if #rs == 1 then
                newXt:insert(k, rs[1])
            else
                newXt:insert(rs[2], rs[1])
            end
        end
    return newXt
end

function xtable:filter(pred)
    local newXt = xtable.new()
    for ik, nk, v in self:trios() do
        if pred(v, nk, ik) then
            newXt:insert(nk, v)
        end
    end
    return newXt
end

function xtable:reduce(reducer, initValue)
    local acc = initValue
    local first = true
    for ik, nk, v in self:trios() do
        if first and acc == nil then
            acc = v
            first = false
        else
            acc = reducer(acc, v, nk, ik)
        end
    end
    return acc
end

function xtable:all(pred)
    for ik, nk, v in self:trios() do
        if not pred(v, nk, ik) then
            return false
        end
    end
    return true
end

function xtable:any(pred)
    for ik, nk, v in self:trios() do
        if pred == nil or pred(v, nk, ik) then
            return true
        end
    end
    return false
end

function xtable:each(actFn)
    for ik, nk, v in self:trios() do
        actFn(v, nk, ik)
    end
end

function xtable:find(pred)
    for ik, nk, v in self:trios() do
        if pred(v, nk, ik) then
            return v, nk, ik
        end
    end
end

function xtable:findLast(pred)
    for ik, nk, v in self:triosReversed() do
        if pred(v, nk, ik) then
            return v, nk, ik
        end
    end
end

function xtable:first()
    return self:getByIKey(1)
end

function xtable:last()
    local len = #self._nodes
    if len > 0 then
        return self:getByIKey(len)
    end
end

function xtable:single()
    local len = #self._nodes
    if len == 1 then
        return self:getByIKey(1)
    end
end

function xtable:take(n)
    local newXt = xtable.new()
    for ik, nk, v in self:trios() do
        if ik <= n then
            newXt:insert(nk, v)
        else
            break
        end
    end
    return newXt
end

function xtable:skip(n)
    local newXt = xtable.new()
    for ik, nk, v in self:trios() do
        if ik > n then
            newXt:insert(nk, v)
        end
    end
    return newXt
end

function xtable:distinct()
    local seen = {}
    local newXt = xtable.new()
    for _, nk, v in self:trios() do
        if seen[v] == nil then
            newXt:insert(nk, v)
            seen[v] = true
        end
    end
    return newXt
end

-- todo! testing, performance
function xtable:getByValue(value)
    return self:find(function(v)
        return v == value
    end)
end

-- todo! testing, performance
function xtable:hasValue(value)
    return self:getByValue(value) ~= nil
end

return xtable
