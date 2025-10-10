local util = {}

util.pack = table.pack or function(...) return { n = select("#", ...), ... } end
util.unpack = table.unpack or unpack
util.eq = function(x, y) return x == y end
util.noop = function() end
util.identity = function(x) return x end
util.constant = function(x) return function() return x end end
util.isa = function(object, class)
  return type(object) == "table" and getmetatable(object) and getmetatable(object).__index == class
end
util.isArray = function(t)
  -- Quick check: if #t is nonzero and the last slot is nil, it cannot be dense
  if #t > 0 and t[#t] == nil then
    return false
  end
  -- Ensure that all keys are consecutive integers from 1..#t
  local count = 0
  for k in pairs(t) do
    if type(k) ~= "number" or k < 1 or k > #t or (k % 1 ~= 0) then
      return false
    end
    count = count + 1
  end
  -- Final check: total numeric keys must match #t
  return count == #t
end
util.shallowCopy = function(value)
  if type(value) ~= 'table' then
    return value
  end
  local newTable = {}
  for k, v in pairs(value) do
    newTable[k] = v
  end
  return newTable
end
util.strict_eq = function(t1, t2)
  if type(t1) ~= type(t2) then return false end
  if type(t1) ~= 'table' then return t1 == t2 end
  for k, _ in pairs(t1) do
    if not util.strict_eq(t1[k], t2[k]) then return false end
  end
  for k, _ in pairs(t2) do
    if not util.strict_eq(t2[k], t1[k]) then return false end
  end
  return true
end
util.if_ = function(cond) return {
  then_ = function(then_v) return {
    else_ = function(else_v)
      if cond then return then_v else return else_v end
    end,
    elseNil = function()
      if cond then return then_v else return nil end
    end
  } end
} end
util.nvl = function(v, else_v)
  return util.if_(v ~= nil).then_(v).else_(else_v)
end
util.nvl2 = function(v, then_v, else_v)
  return util.if_(v ~= nil).then_(then_v).else_(else_v)
end
util._orElse = function(dv, dk, di, fn, ...)
  local v, k, i = fn(...)
  if v ~= nil then
    return v, k, i
  else
    return dv, dk, di
  end
end
util._orError = function(msg, fn, ...)
  local rs = util.pack(fn(...))
  if rs[1] ~= nil then
    return util.unpack(rs, 1, rs.n)
  else
    error(msg)
  end
end

return util
