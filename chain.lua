-- ilua-chain v0.0.1
-- https://github.com/MuravevIV/ilua-chain
-- MIT License

local serpent = (function()
    local n, v = "serpent", "0.303" -- (C) 2012-18 Paul Kulchenko; MIT License
    local c, d = "Paul Kulchenko", "Lua serializer and pretty printer"
    local snum = {[tostring(1/0)]='1/0 --[[math.huge]]',[tostring(-1/0)]='-1/0 --[[-math.huge]]',[tostring(0/0)]='0/0'}
    local badtype = {thread = true, userdata = true, cdata = true}
    local getmetatable = debug and debug.getmetatable or getmetatable
    local pairs = function(t) return next, t end -- avoid using __pairs in Lua 5.2+
    local keyword, globals, G = {}, {}, (_G or _ENV)
    for _,k in ipairs({'and', 'break', 'do', 'else', 'elseif', 'end', 'false',
      'for', 'function', 'goto', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat',
      'return', 'then', 'true', 'until', 'while'}) do keyword[k] = true end
    for k,v in pairs(G) do globals[v] = k end -- build func to name mapping
    for _,g in ipairs({'coroutine', 'debug', 'io', 'math', 'string', 'table', 'os'}) do
      for k,v in pairs(type(G[g]) == 'table' and G[g] or {}) do globals[v] = g..'.'..k end end
    
    local function s(t, opts)
      local name, indent, fatal, maxnum = opts.name, opts.indent, opts.fatal, opts.maxnum
      local sparse, custom, huge = opts.sparse, opts.custom, not opts.nohuge
      local space, maxl = (opts.compact and '' or ' '), (opts.maxlevel or math.huge)
      local maxlen, metatostring = tonumber(opts.maxlength), opts.metatostring
      local iname, comm = '_'..(name or ''), opts.comment and (tonumber(opts.comment) or math.huge)
      local numformat = opts.numformat or "%.17g"
      local seen, sref, syms, symn = {}, {'local '..iname..'={}'}, {}, 0
      local function gensym(val) return '_'..(tostring(tostring(val)):gsub("[^%w]",""):gsub("(%d%w+)",
        -- tostring(val) is needed because __tostring may return a non-string value
        function(s) if not syms[s] then symn = symn+1; syms[s] = symn end return tostring(syms[s]) end)) end
      local function safestr(s) return type(s) == "number" and (huge and snum[tostring(s)] or numformat:format(s))
        or type(s) ~= "string" and tostring(s) -- escape NEWLINE/010 and EOF/026
        or ("%q"):format(s):gsub("\010","n"):gsub("\026","\\026") end
      -- handle radix changes in some locales
      if opts.fixradix and (".1f"):format(1.2) ~= "1.2" then
        local origsafestr = safestr
        safestr = function(s) return type(s) == "number"
          and (nohuge and snum[tostring(s)] or numformat:format(s):gsub(",",".")) or origsafestr(s)
        end
      end
      local function comment(s,l) return comm and (l or 0) < comm and ' --[['..select(2, pcall(tostring, s))..']]' or '' end
      local function globerr(s,l) return globals[s] and globals[s]..comment(s,l) or not fatal
        and safestr(select(2, pcall(tostring, s))) or error("Can't serialize "..tostring(s)) end
      local function safename(path, name) -- generates foo.bar, foo[3], or foo['b a r']
        local n = name == nil and '' or name
        local plain = type(n) == "string" and n:match("^[%l%u_][%w_]*$") and not keyword[n]
        local safe = plain and n or '['..safestr(n)..']'
        return (path or '')..(plain and path and '.' or '')..safe, safe end
      local alphanumsort = type(opts.sortkeys) == 'function' and opts.sortkeys or function(k, o, n) -- k=keys, o=originaltable, n=padding
        local maxn, to = tonumber(n) or 12, {number = 'a', string = 'b'}
        local function padnum(d) return ("%0"..tostring(maxn).."d"):format(tonumber(d)) end
        table.sort(k, function(a,b)
          -- sort numeric keys first: k[key] is not nil for numerical keys
          return (k[a] ~= nil and 0 or to[type(a)] or 'z')..(tostring(a):gsub("%d+",padnum))
               < (k[b] ~= nil and 0 or to[type(b)] or 'z')..(tostring(b):gsub("%d+",padnum)) end) end
      local function val2str(t, name, indent, insref, path, plainindex, level)
        local ttype, level, mt = type(t), (level or 0), getmetatable(t)
        local spath, sname = safename(path, name)
        local tag = plainindex and
          ((type(name) == "number") and '' or name..space..'='..space) or
          (name ~= nil and sname..space..'='..space or '')
        if seen[t] then -- already seen this element
          sref[#sref+1] = spath..space..'='..space..seen[t]
          return tag..'nil'..comment('ref', level)
        end
        -- protect from those cases where __tostring may fail
        if type(mt) == 'table' and metatostring ~= false then
          local to, tr = pcall(function() return mt.__tostring(t) end)
          local so, sr = pcall(function() return mt.__serialize(t) end)
          if (to or so) then -- knows how to serialize itself
            seen[t] = insref or spath
            t = so and sr or tr
            ttype = type(t)
          end -- new value falls through to be serialized
        end
        if ttype == "table" then
          if level >= maxl then return tag..'{}'..comment('maxlvl', level) end
          seen[t] = insref or spath
          if next(t) == nil then return tag..'{}'..comment(t, level) end -- table empty
          if maxlen and maxlen < 0 then return tag..'{}'..comment('maxlen', level) end
          local maxn, o, out = math.min(#t, maxnum or #t), {}, {}
          for key = 1, maxn do o[key] = key end
          if not maxnum or #o < maxnum then
            local n = #o -- n = n + 1; o[n] is much faster than o[#o+1] on large tables
            for key in pairs(t) do
              if o[key] ~= key then n = n + 1; o[n] = key end
            end
          end
          if maxnum and #o > maxnum then o[maxnum+1] = nil end
          if opts.sortkeys and #o > maxn then alphanumsort(o, t, opts.sortkeys) end
          local sparse = sparse and #o > maxn -- disable sparsness if only numeric keys (shorter output)
          for n, key in ipairs(o) do
            local value, ktype, plainindex = t[key], type(key), n <= maxn and not sparse
            if opts.valignore and opts.valignore[value] -- skip ignored values; do nothing
            or opts.keyallow and not opts.keyallow[key]
            or opts.keyignore and opts.keyignore[key]
            or opts.valtypeignore and opts.valtypeignore[type(value)] -- skipping ignored value types
            or sparse and value == nil then -- skipping nils; do nothing
            elseif ktype == 'table' or ktype == 'function' or badtype[ktype] then
              if not seen[key] and not globals[key] then
                sref[#sref+1] = 'placeholder'
                local sname = safename(iname, gensym(key)) -- iname is table for local variables
                sref[#sref] = val2str(key,sname,indent,sname,iname,true)
              end
              sref[#sref+1] = 'placeholder'
              local path = seen[t]..'['..tostring(seen[key] or globals[key] or gensym(key))..']'
              sref[#sref] = path..space..'='..space..tostring(seen[value] or val2str(value,nil,indent,path))
            else
              out[#out+1] = val2str(value,key,indent,nil,seen[t],plainindex,level+1)
              if maxlen then
                maxlen = maxlen - #out[#out]
                if maxlen < 0 then break end
              end
            end
          end
          local prefix = string.rep(indent or '', level)
          local head = indent and '{\n'..prefix..indent or '{'
          local body = table.concat(out, ','..(indent and '\n'..prefix..indent or space))
          local tail = indent and "\n"..prefix..'}' or '}'
          return (custom and custom(tag,head,body,tail,level) or tag..head..body..tail)..comment(t, level)
        elseif badtype[ttype] then
          seen[t] = insref or spath
          return tag..globerr(t, level)
        elseif ttype == 'function' then
          seen[t] = insref or spath
          if opts.nocode then return tag.."function() --[[..skipped..]] end"..comment(t, level) end
          local ok, res = pcall(string.dump, t)
          local func = ok and "((loadstring or load)("..safestr(res)..",'@serialized'))"..comment(t, level)
          return tag..(func or globerr(t, level))
        else return tag..safestr(t) end -- handle all other types
      end
      local sepr = indent and "\n" or ";"..space
      local body = val2str(t, name, indent) -- this call also populates sref
      local tail = #sref>1 and table.concat(sref, sepr)..sepr or ''
      local warn = opts.comment and #sref>1 and space.."--[[incomplete output with shared/self-references skipped]]" or ''
      return not name and body..warn or "do local "..body..sepr..tail.."return "..name..sepr.."end"
    end
    
    local function deserialize(data, opts)
      local env = (opts and opts.safe == false) and G
        or setmetatable({}, {
            __index = function(t,k) return t end,
            __call = function(t,...) error("cannot call functions") end
          })
      local f, res = (loadstring or load)('return '..data, nil, nil, env)
      if not f then f, res = (loadstring or load)(data, nil, nil, env) end
      if not f then return f, res end
      if setfenv then setfenv(f, env) end
      return pcall(f)
    end
    
    local function merge(a, b) if b then for k,v in pairs(b) do a[k] = v end end; return a; end
    return { _NAME = n, _COPYRIGHT = c, _DESCRIPTION = d, _VERSION = v, serialize = s,
      load = deserialize,
      dump = function(a, opts) return s(a, merge({name = '_', compact = true, sparse = true}, opts)) end,
      line = function(a, opts) return s(a, merge({sortkeys = true, comment = true}, opts)) end,
      block = function(a, opts) return s(a, merge({indent = '  ', sortkeys = true, comment = true}, opts)) end }
end)()

local util = (function()
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
end)()

local asserts = (function()
    -- asserts.lua
    -- A lightweight, fluent assertion library with rich, contextual error messages.
    
    -- NEW: Shim for environments without the `debug` library.
    -- If the global `debug` library or its necessary functions are not available,
    -- we create a local shim that provides default, "unknown" values. This allows
    -- the library to function without crashing, albeit with less detailed error messages.
    local local_debug
    if not debug or not debug.getinfo or not debug.getlocal then
        local debug_shim = {}
    
        --- Returns a default info table.
        function debug_shim.getinfo(...)
            return {
                name = "unknown",
                nparams = 0,
                isvararg = false,
            }
        end
    
        --- Always returns nil, indicating no locals were found.
        function debug_shim.getlocal(...)
            return nil
        end
    
        -- The local 'local_debug' will now refer to our shim within this file's scope.
        local_debug = debug_shim
    else
        local_debug = debug
    end
    
    local M = {}
    
    local TRUNCATE_LIMIT = 60
    
    ---
    -- Uses the local_debug library to find the name of the function, its parameter list,
    -- and the name of the variable being asserted. This is for creating high-quality,
    -- context-aware error messages.
    -- @param lvl The local_debug stack level to inspect.
    -- @param val The value being checked, used to find the corresponding local.
    -- @return A context table: { fn, var, params_str }.
    local function getContext(lvl, val)
        -- This call will now use either the real 'local_debug' library or our shim.
        local info = local_debug.getinfo(lvl, "nu")
        if not info then
            return { fn = "unknown", var = "argument", params_str = "" }
        end
    
        local ctx = {
            fn = info.name or "unknown",
            var = "argument", -- Default value
            params_str = ""
        }
    
        -- 1. Build the parameter signature string
        local param_names = {}
        -- If using the shim, info.nparams will be 0, so this loop is skipped.
        for i = 1, info.nparams do
            local name = local_debug.getlocal(lvl, i)
            if name then
                -- NEW: Hide the implicit 'self' parameter from method call signatures.
                if not (i == 1 and name == "self") then
                    table.insert(param_names, name)
                end
            end
        end
        ctx.params_str = table.concat(param_names, ", ")
        if info.isvararg then
            ctx.params_str = #param_names > 0 and (ctx.params_str .. ", ...") or "..."
        end
    
        -- 2. Find the specific variable name that matches the failing value
        -- If using the shim, local_debug.getlocal will return nil, so this loop breaks immediately.
        for i = 1, 200 do
            local n, v = local_debug.getlocal(lvl, i)
            if not n then break end
            if n:sub(1, 1) ~= '(' and rawequal(v, val) then
                ctx.var = n
                break
            end
        end
    
        return ctx
    end
    
    ---
    -- Formats a simple value for inclusion in an error message.
    -- Returns nil for complex types as the type name alone is sufficient.
    -- @param val The value to format.
    -- @return A formatted string or nil.
    local function format_value(val)
        local t = type(val)
        if t == "number" or t == "boolean" then
            return tostring(val)
        elseif t == "string" then
            if #val > TRUNCATE_LIMIT then
                return "'" .. val:sub(1, TRUNCATE_LIMIT) .. "...'"
            else
                return "'" .. val .. "'"
            end
        end
        return nil
    end
    
    ---
    -- A factory function that creates an assertion function.
    -- @param predicate A function that returns true on success, or false/string on failure.
    -- @param type_str A string describing the expected type (e.g., "a string").
    -- @param is_optional If true, the generated assertion will pass if the value is nil.
    -- @return The generated assertion function.
    local function creator(predicate, type_str, is_optional)
        return function(val)
            if is_optional and val == nil then return val end
    
            local result = predicate(val)
            if result == true then return val end
    
            local got_description = type(result) == "string" and result or type(val)
    
            local value_clarification = format_value(val)
            local final_got_str = got_description
            if value_clarification then
                final_got_str = final_got_str .. ": " .. value_clarification
            end
    
            local ctx = getContext(3, val)
            local msg = ("%s(%s): %s must be %s (got %s)"):format(
                ctx.fn, ctx.params_str, ctx.var, type_str, final_got_str)
            error(msg, 2)
        end
    end
    
    -- Configuration table for generating standard assertions.
    local assertions_to_create = {
        { name = "is_function", pred = function(v) return type(v) == "function" end, type_str = "a function" },
        { name = "is_string",   pred = function(v) return type(v) == "string"   end, type_str = "a string"   },
        {
            name = "is_non_empty_string",
            type_str = "a non-empty string",
            pred = function(v)
                if type(v) ~= "string" then return false end
                return #v > 0 or "an empty string"
            end,
        },
        { name = "is_number",   pred = function(v) return type(v) == "number"   end, type_str = "a number"   },
        { name = "is_table",    pred = function(v) return type(v) == "table"    end, type_str = "a table"    },
        { name = "is_boolean",  pred = function(v) return type(v) == "boolean"  end, type_str = "a boolean"  },
        {
            name = "is_integer",
            type_str = "an integer",
            pred = function(v)
                if type(v) ~= "number" then return false end
                return v % 1 == 0 or "a non-integer number"
            end,
        },
        {
            name = "is_not_zero",
            type_str = "a non-zero number",
            pred = function(v)
                if type(v) ~= "number" then return false end
                return v ~= 0 or "a zero number"
            end,
        },
        {
            name = "is_array",
            type_str = "an array-like table",
            pred = function(v)
                if type(v) ~= "table" then return false end
                local n = #v
                for i = 1, n do if v[i] == nil then return false end end
                return v[n + 1] == nil or "a hash-like table"
            end,
        },
    }
    
    ---
    -- A fluent interface for assertions on optional values.
    -- @example `asserts.if_present_then.is_string(optional_str)`
    M.if_present_then = {}
    
    -- Generate all standard, _or_nil, and if_present_then assertions
    for _, def in ipairs(assertions_to_create) do
        -- 1. Create the standard (non-optional) assertion
        M[def.name] = creator(def.pred, def.type_str, false)
    
        -- 2. Create the optional assertion (passes on nil)
        local optional_assertion = creator(def.pred, def.type_str .. " or nil", true)
    
        -- 3. Assign the optional assertion to both the `_or_nil` and `if_present_then` variants
        M[def.name .. "_or_nil"] = optional_assertion
        M.if_present_then[def.name] = optional_assertion
    end
    
    ---
    -- Standalone assertions that don't fit the `creator` pattern.
    ---
    
    ---
    -- Asserts that a value is not nil.
    function M.is_not_nil(val)
        if val ~= nil then return val end
        local ctx = getContext(3, val)
        local msg = ("%s(%s): %s must not be nil (got nil)"):format(
            ctx.fn, ctx.params_str, ctx.var)
        error(msg, 2)
    end
    
    -- `exists` is a common alias for `is_not_nil`, provided for semantic convenience.
    M.exists = M.is_not_nil
    
    return M
end)()

local xtable = (function()
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
        if existing_iKey then
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
        local len = #self
        if len > 0 then
            return self:getByIKey(len)
        end
    end
    
    function xtable:single()
        local len = #self
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
end)()

local slice = (function()
    local function _sliceNormalizeIndices(length, s_orig, e_orig, p_orig)
      -- This internal helper calculates the final 0-based pStart (inclusive),
      -- end (exclusive), and step values for iteration, mimicking Python's
      -- slice.indices(length) behavior.
      local step
      if p_orig == nil then
        step = 1
      else
        step = p_orig
      end
      if step == 0 then
        -- Level 2 reports error from the perspective of slice's caller.
        error("slice: slice pStep cannot be zero", 2)
      end
      local start_idx, end_idx
      if step > 0 then
        -- Handle pStart for step > 0
        if s_orig == nil then
          start_idx = 0
        else
          start_idx = s_orig
          if start_idx < 0 then
            start_idx = start_idx + length
          end
          if start_idx < 0 then -- Still negative (e.g., s_orig was -length - k)
            start_idx = 0
          elseif start_idx > length then -- Past the end
            start_idx = length
          end
        end
        -- Handle end for step > 0
        if e_orig == nil then
          end_idx = length
        else
          end_idx = e_orig
          if end_idx < 0 then
            end_idx = end_idx + length
          end
          if end_idx < 0 then -- Still negative
            end_idx = 0
          elseif end_idx > length then -- Past the end
            end_idx = length
          end
        end
        -- Ensure end_idx is not less than start_idx for positive step
        if end_idx < start_idx then
          end_idx = start_idx
        end
      else -- step < 0
        -- Handle pStart for step < 0
        if s_orig == nil then
          start_idx = length - 1
        else
          start_idx = s_orig
          if start_idx < 0 then
            start_idx = start_idx + length
          end
          if start_idx < -1 then -- Clamp very negative to -1
            start_idx = -1
          elseif start_idx >= length then -- Clamp very positive to length-1
            start_idx = length - 1
          end
        end
        -- Handle end for step < 0
        if e_orig == nil then
          end_idx = -1 -- Sentinel for "before the beginning"
        else
          end_idx = e_orig
          if end_idx < 0 then
            end_idx = end_idx + length
          end
          if end_idx < -1 then -- Clamp very negative to -1
            end_idx = -1
            -- No specific upper clamp like `length-1` for end_idx with negative step.
            -- Python's behavior: e.g., `arr[3:10:-1]` is empty.
            -- The `end_idx > start_idx` check below handles this.
          end
        end
        -- Ensure end_idx is not greater than start_idx for negative step
        if end_idx > start_idx then
          end_idx = start_idx
        end
      end
      return start_idx, end_idx, step
    end
    
    local function slice(xt, pStart, pEnd, pStep, shiftPos)
      if type(xt) ~= "table" then
        error("slice: input 'tbl' must be a table", 2)
      end
      if shiftPos ~= 0 and shiftPos ~= 1 then
        error("slice: 'shiftPos' must be 0 or 1", 2)
      end
      local n = #xt
      local py_start, py_end -- These will be nil or 0-based integer indices
      -- Convert input pStart/end to 0-based Python-style nil-or-integer values.
      -- `pStep` is passed directly to _sliceNormalizeIndices.
      if shiftPos == 1 then -- Lua 1-based input
        if pStart ~= nil then
          if type(pStart) ~= "number" then error("slice: 'pStart' must be a number or nil for shiftPos=1", 2) end
          if pStart > 0 then
            py_start = pStart - 1
          else -- pStart <= 0 (Lua negative indices: -1 is #tbl, etc.)
            py_start = n + pStart
          end
        end -- else py_start remains nil
        if pEnd ~= nil then
          if type(pEnd) ~= "number" then error("slice: 'pEnd' must be a number or nil for shiftPos=1", 2) end
          if pEnd > 0 then
            -- Lua end X (1-based) means up to element X.
            -- Python slice end Y (0-based, exclusive) for element at 0-based index X-1 must be X.
            py_end = pEnd
          else -- pEnd <= 0 (Lua negative indices)
            py_end = n + pEnd
          end
        end -- else py_end remains nil
      else -- Python 0-based input
        if pStart ~= nil and type(pStart) ~= "number" then error("slice: 'pStart' must be a number or nil", 2) end
        if pEnd ~= nil and type(pEnd) ~= "number" then error("slice: 'pEnd' must be a number or nil", 2) end
        py_start = pStart
        py_end = pEnd
      end
      if pStep ~= nil and type(pStep) ~= "number" then error("slice: 'pStep' must be a number or nil", 2) end
      local norm_start, norm_stop, norm_step = _sliceNormalizeIndices(n, py_start, py_end, pStep)
      local current_0_based_idx -- Current 0-based index for iteration
    
      local newXt = xtable.new()
      if norm_step > 0 then
        current_0_based_idx = norm_start
        while current_0_based_idx < norm_stop do
          -- Access tbl using 1-based index from 0-based current_0_based_idx
          local v, nk = xt:getByIKey(current_0_based_idx + 1)
          newXt:insert(nk, v)
          current_0_based_idx = current_0_based_idx + norm_step
        end
      elseif norm_step < 0 then
        current_0_based_idx = norm_start
        while current_0_based_idx > norm_stop do -- Note: comparison is '>' for negative step
          local v, nk = xt:getByIKey(current_0_based_idx + 1)
          newXt:insert(nk, v)
          current_0_based_idx = current_0_based_idx + norm_step
        end
      end
      -- If norm_step == 0, _sliceNormalizeIndices would have already raised an error.
      return newXt
    end
    
    return slice
end)()

---@class Chain
local Chain = {}
Chain.__index = Chain

--- Creates a new Chain from a source table or Chain
---@param source table|userdata|Chain Source collection or Chain
---@return Chain
function Chain.new(source)
    if util.isa(source, Chain) then
        return source
    end
    if xtable.isXTable(source) then
        return setmetatable({ _xt = source }, Chain)
    end
    local cType = type(source)
    if cType ~= "table" and cType ~= "userdata" then
        error("chain(..) expects a table, compatible userdata, or an existing Chain instance. Got type: " .. cType, 2)
    end
    local newXt = xtable.fromUPairs(source)
    return setmetatable({ _xt = newXt }, Chain)
end

--- Creates an empty Chain
---@return Chain
function Chain.empty()
    return setmetatable({ _xt = xtable.new() }, Chain)
end

--- Unwraps a Chain to its underlying collection
---@param source table|Chain Source collection or Chain
---@return table|nil
function Chain.unwrap(source)
    if util.isa(source, Chain) then
        return source:toMap()
    elseif type(source) == "table" then
        return source
    else
        return nil
    end
end

function Chain:__pairs()
    return self._xt:pairs()
end

--- Checks if all elements satisfy `pred(value, [key, index])`. True if empty.
--- @param pred function Function `function(value, [key, index])`.
--- @return boolean True if all elements satisfy (or chain is empty).
function Chain:all(pred)
    asserts.is_function(pred)
    return self._xt:all(pred)
end

--- Checks if any element satisfies `pred(value, [key, index])`.
--- @param pred function optional - Function `function(value, [key, index])`.
--- @return boolean True if any element satisfies the predicate, False otherwise. If predicate is missing - returns True if chain contains at least one element, False otherwise.
function Chain:any(pred)
    asserts.is_function_or_nil(pred)
    return self._xt:any(pred)
end

--- Asserts that chain has at least `n` elements, throws assertion error if not. Returns `self`.
--- @param n number Minimum expected count.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertCountAtLeast(n, msg)
    local cnt = #self._xt
    local m = msg or "Chain:assertCountAtLeast failed: Expected count of at least " .. n .. "."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt >= n, ms)
    return self
end

--- Asserts that chain has at most `n` elements, throws assertion error if not. Returns `self`.
--- @param n number Maximum expected count.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertCountAtMost(n, msg)
    local cnt = #self._xt
    local m = msg or "Chain:assertCountAtMost failed: Expected count of at most " .. n .. "."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt <= n, ms)
    return self
end

--- Asserts that chain has exactly `n` elements, throws assertion error if not. Returns `self`.
--- @param n number Expected count.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertCountEquals(n, msg)
    local cnt = #self._xt
    local m = msg or "Chain:assertCountEquals failed: Expected count of " .. n .. "."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt == n, ms)
    return self
end

-- todo! docs
function Chain:assertEquals(expected) -- todo! test
    local actual = self._xt:toMap()
    local isEquals = util.strict_eq(actual, expected)
    local expectedRepr = serpent.serialize(expected, {})
    local actualRepr = serpent.serialize(actual, {})
    if not isEquals then
        error("Not equal:\n\t\t\tExpected: " .. expectedRepr .. "\n\t\t\tActual:   " .. actualRepr, 2)
    end
    return self
end

--- Asserts that chain is empty, throws assertion error if it is not. Returns `self`.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertIsEmpty(msg)
    local cnt = #self._xt
    local m = msg or "Chain:assertIsEmpty failed: The collection is not empty."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt == 0, ms)
    return self
end

--- Asserts that chain is not empty, throws assertion error if it is. Returns `self`.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertIsNotEmpty(msg)
    local m = msg or "Chain:assertIsNotEmpty failed: The collection is empty."
    assert(#self._xt > 0, m)
    return self
end

--- Asserts that chain has exactly one element, throws assertion error if not. Returns `self`.
--- @param msg string optional - Custom assertion error message.
--- @return Chain The current Chain object.
function Chain:assertSingle(msg)
    local cnt = #self._xt
    local m = msg or "Chain:assertSingle failed: Expected exactly one element."
    local ms = string.format("%s (Found %d elements).", m, cnt)
    assert(cnt == 1, ms)
    return self
end

--- Creates a map by taking each value-table element, using the value of `fieldName` as the new key.
--- Non-table elements are skipped. Table elements lacking `fieldName` are also skipped.
--- In case of duplicate keys, the first occurrence takes precedence.
---
--- Example:
--- ```
--- local data = {
---   {role = "admin", name = "Alice"},
---   {role = "user",  name = "Bob"},
---   {role = "guest", name = "Charlie"}
--- }
---
--- local result = chain(data):copyFieldToKey("role"):toList()
---
--- result == {
---   admin = {role = "admin", name = "Alice"},
---   user  = {role = "user",  name = "Bob"},
---   guest = {role = "guest", name = "Charlie"}
--- }
--- ```
---
--- @param fieldName string The field whose value will become the new map key
--- @return Chain A new Chain containing a map keyed by the specified field
function Chain:copyFieldToKey(fieldName)
    asserts.is_non_empty_string(fieldName)
    local newXt = xtable.new()
    for _, _, v in self._xt:trios() do
        if type(v) == "table" then
            local keyVal = v[fieldName]
            if keyVal ~= nil and newXt:getByNKey(keyVal) == nil then
                newXt:insert(keyVal, v)
            end
        end
    end
    return Chain.new(newXt)
end

--- Iterates underlying collection (expected map-like). For each entry,
--- if value is a table, copies original key to value-table under `fieldName`.
--- Replaces `fieldName` field if it exists for value-tables.
--- Returns new chain of these modified values as a map.
---
--- Example:
--- ```
--- local data = {
---   admin = {name = "Alice",   level = 10},
---   user  = {name = "Bob",     level = 5},
---   guest = {name = "Charlie", level = 1}
--- }
---
--- local result = chain(data):copyKeyToField("role"):toList()
---
--- result == {
---   admin = {name = "Alice",   level = 10, role = "admin"},
---   user  = {name = "Bob",     level = 5,  role = "user"},
---   guest = {name = "Charlie", level = 1,  role = "guest"}
--- }
--- ```
---
--- @param fieldName string Name of the field to store the original key.
--- @return Chain A new Chain where elements (if tables) have original key added, preserved as a map.
function Chain:copyKeyToField(fieldName)
    asserts.is_non_empty_string(fieldName)
    local newXt = xtable.new()
    for _, nk, v in self._xt:trios() do
        if type(v) == "table" then
            local newVal = util.shallowCopy(v)
            newVal[fieldName] = nk
            newXt:insert(nk, newVal)
        else
            newXt:insert(nk, v)
        end
    end
    return Chain.new(newXt)
end

--- Returns number of elements.
--- @return number Count of elements.
function Chain:count()
    return #self._xt
end

-- todo! docs and tests
function Chain:decapsule()
    return Chain.new(self._xt:map(function(v)
        if type(v) == "table" then
            local first, single, ck1, cv1 = true, true, nil, nil
            for ck, cv in pairs(v) do
                if first then
                    first, ck1, cv1 = false, ck, cv
                else
                    single = false
                    break
                end
            end
            if single then
                return cv1, ck1
            end
        end
    end))
end

--- Returns new chain with distinct elements, preserving first-occurrence order.
--- Distinctiveness by identity (reference for tables, value for primitives).
--- @return Chain A new Chain object with distinct elements.
function Chain:distinct()
    return Chain.new(self._xt:distinct())
end

--- For each table element in the chain, creates a new table excluding the specified fields.
--- If an element is array-table or not a table - it is passed through unchanged.
--- Numeric-keyed fields could not be dropped.
--- @param fieldsToDrop table A sequence table of string field names to drop.
--- @return Chain A new Chain where table elements have the specified fields removed.
function Chain:dropFields(fieldsToDrop)
    asserts.is_table(fieldsToDrop)
    local dropSet = {}
    for _, fName in ipairs(fieldsToDrop) do
        dropSet[fName] = true
    end
    local newXt = xtable.new()
    for _, nk, v in self._xt:trios() do
        if type(v) ~= "table" or util.isArray(v) then
            newXt:insert(nk, v)
        else
            local newValue = {}
            for ck, cv in pairs(v) do
                if not dropSet[ck] then
                    newValue[ck] = cv
                end
            end
            newXt:insert(nk, newValue)
        end
    end
    return Chain.new(newXt)
end

-- todo! docs and tests
function Chain:encapsule()
    return Chain.new(self._xt:map(function(v, k, idx)
        return  { [k] = v }, idx
    end))
end

--- Filters the elements of the chain based on a predicate function, returning a new Chain.
--- @param pred function The predicate `function(value, [key, index])`.
--- @return Chain A new Chain containing filtered elements.
function Chain:filter(pred)
    asserts.is_function(pred)
    return Chain.new(self._xt:filter(pred))
end

--- Filters the elements of the chain based on an inverse of a predicate function.
--- The predicate function receives `(value, [key, index])`.
--- @param pred function The inverse filtering function `function(value, [key, index])`.
--- @return Chain A new Chain object containing the filtered elements.
function Chain:filterNot(pred)
    asserts.is_function(pred)
    return Chain.new(self._xt:filter(function(...)
        return not pred(...)
    end))
end

--- Finds the first element satisfying `pred(value, [key, index])`, or returns `nil`.
--- @param pred function The predicate `function(value, [key, index])`.
--- @return any The first matching element as `value, [key, index]`, or `nil`.
function Chain:findFirstOrNil(pred)
    asserts.is_function(pred)
    return self._xt:find(pred)
end

--- Finds the first element satisfying `pred(value, [key, index])`, or returns `defaultVal`.
--- @param pred function The predicate `function(value, [key, index])`.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The first matching element as `value, [key, index]`, or `defaultVal`.
function Chain:findFirstOrElse(pred, dv, dk, di)
    asserts.is_function(pred)
    asserts.is_not_nil(dv)
    return util._orElse(dv, dk, di, self._xt.find, self._xt, pred)
end

--- Finds the first element satisfying `pred(value, [key, index])`, or throws an error.
--- @param pred function The predicate `function(value, [key, index])`.
--- @param msg? string Custom error message.
--- @return any The first matching element as `value, [key, index]`.
function Chain:findFirstOrError(pred, msg)
    asserts.is_function(pred)
    msg = msg or "findFirstOrError(..) failed: no element found by predicate"
    return util._orError(msg, self._xt.find, self._xt, pred)
end

--- Finds the last element satisfying `pred(value, key)`, or returns `nil`.
--- @param pred function The predicate `function(value, key)`.
--- @return any The last matching element, or `nil`.
function Chain:findLastOrNil(pred)
    asserts.is_function(pred)
    return self._xt:findLast(pred)
end

--- Finds the last element satisfying `pred(value, [key, index])`, or returns default value/key/index.
--- @param pred function The predicate `function(value, [key, index])`.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The last matching element as `value, [key, index]`, or `dv, [dk, di]` if last matching element is not found.
function Chain:findLastOrElse(pred, dv, dk, di)
    asserts.is_function(pred)
    asserts.if_present_then.is_integer(di)
    return util._orElse(dv, dk, di, self._xt.findLast, self._xt, pred)
end

--- Finds the last element satisfying `pred(value, [key, index])`, or throws an error.
--- @param pred function The predicate `function(value, [key, index])`.
--- @param msg string optional - Custom error message.
--- @return any The last matching element as `value, [key, index]`.
function Chain:findLastOrError(pred, msg)
    asserts.is_function(pred)
    msg = msg or "findLastOrError(..) failed: no element found by predicate"
    return util._orError(msg, self._xt.findLast, self._xt, pred)
end

--- Returns the first element, or `nil` if the chain is empty.
--- @return any The first element as `value, [key, index]`, or `nil`.
function Chain:firstOrNil()
    return self._xt:first()
end

--- Returns the first element, or `defaultVal` if the chain is empty.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The first element as `value, [key, index]`, or `dv, [dk, di]` if chain is empty.
function Chain:firstOrElse(dv, dk, di)
    asserts.if_present_then.is_integer(di)
    return util._orElse(dv, dk, di, self._xt.first, self._xt)
end

--- Finds the first element, or throws an error if the chain is empty.
--- @param msg string optional - Custom error message.
--- @return any The first element as `value, [key, index]`.
function Chain:firstOrError(msg)
    msg = msg or "firstOrError(..) failed: chain is empty"
    return util._orError(msg, self._xt.first, self._xt)
end

--- Maps elements using `mapper(value, key)` to tables, then flattens results.
--- If `mapper` function returns not-table or nil - the entry is skipped.
--- If `keyMapper` function is missing - the operation does not preserve key information (produces sequence).
--- If `keyMapper` function is present - it's result is used as new keys for flattened entries.
--- If `keyMapper` returns nil - the entry is skipped.
--- In case of duplicate keys returned by `keyMapper` - the first occurrence takes precedence.
--- @param mapper function Function `function(value, key)` expected to return a table or nil.
--- @param keyMapper function optional - Function `function(parentValue, parentKey, parentIndex, childValue, childKey, childIndex)` expected to return a string or nil.
--- @return Chain A new Chain object with flattened elements.
function Chain:flatMap(mapper, keyMapper) -- todo! more unit tests
    asserts.is_function(mapper)
    asserts.if_present_then.is_function(keyMapper)
    local idx = 0
    local newXt = xtable.new()
    for pIK, pNK, pV in self._xt:trios() do
        local mapRes = mapper(pV, pNK, pIK)
        if type(mapRes) == "table" then
            for cNK, cV in pairs(mapRes) do
                idx = idx + 1
                if keyMapper ~= nil then
                    local newKey = keyMapper(pV, pNK, pIK, cV, cNK, idx)
                    if newKey ~= nil then
                        newXt:insert(newKey, cV)
                    end
                else
                    newXt:insert(idx, cV)
                end
            end
        end
    end
    return Chain.new(newXt)
end

--- Applies `actFn(value, key)` to each element for side-effects. Returns `self`.
--- @param actFn function `function(value, key)`.
--- @return Chain The current Chain object.
function Chain:forEach(actFn)
    assert(type(actFn) == "function", "Chain:forEach: actFn must be a function.")
    self._xt:each(actFn)
    return self
end

-- todo! docs and tests
function Chain:forSelf(actFn)
    actFn(self)
    return self
end

function Chain:getAtPositionOrNil(key)
    return self._xt:getByIKey(key) -- todo! specs
end

function Chain:getByKeyOrNil(key)
    return self._xt:getByNKey(key)
end

-- todo! specs
function Chain:getByValueOrNil(key)
    return self._xt:getByValue(key)
end

--- Groups elements based on a key extracted by `keyExtractor(valueElement)`.
--- Returns a Chain with an ordered list of group entries. Each group entry has the form:
--- ```
--- { key = <groupKey>, value = <Chain of all elements sharing groupKey> }
--- ```
--- The order of first appearance of each group key is preserved.
---
--- Example:
--- ```
--- local data = {
---   {type = "admin", name = "Alice"},
---   {type = "user",  name = "Bob"},
---   {type = "admin", name = "Charlie"}
--- }
---
--- local grouped = chain(data)
---     :groupBy(function(valueElement)
---         return valueElement.type
---     end)
---     :toList()
---
--- grouped == {
---   { key = "admin", value = Chain{
---       {type = "admin", name = "Alice"},
---       {type = "admin", name = "Charlie"}
---   }},
---   { key = "user", value = Chain{
---       {type = "user", name = "Bob"}
---   }}
--- }
--- ```
---
--- @param keyExtractor function A function receiving an element and returning the group key.
--- @return Chain A new Chain of group entries.
function Chain:groupBy(keyExtractor)
    assert(type(keyExtractor) == "function", "Chain:groupBy: keyExtractor must be a function.")
    local newXt = xtable.new()
    for i, k, v in self._xt:trios() do
        local groupKey = keyExtractor(v, k, i)
        if groupKey ~= nil then
            local group = newXt:getByNKey(groupKey)
            if group == nil then
                newXt:insert(groupKey, {})
                group = newXt:getByNKey(groupKey)
            end
            table.insert(group, v)
        end
    end
    local finalXt = xtable.new()
    for _, groupKey, groupValues in newXt:trios() do
        finalXt:insert(groupKey, groupValues)
    end
    return Chain.new(finalXt)
end

--- Checks if the chain is empty.
--- @return boolean True if the chain contains no elements.
function Chain:isEmpty()
    return #self._xt == 0
end

--- Checks if the chain is not empty.
--- @return boolean True if the chain contains one or more elements.
function Chain:isNotEmpty()
    return #self._xt > 0
end

--- Returns new chain of all keys from a chain.
--- @return Chain A new Chain object containing keys.
function Chain:keys()
    local newXt = xtable.new()
    for ik, nk, _ in self._xt:trios() do
        newXt:insert(ik, nk)
    end
    return Chain.new(newXt)
end

--- Returns the last element as `value, [key, index]`, or `nil, [nil, nil]` if chain is empty.
--- @return any The last element as `value, [key, index]`, or `nil, [nil, nil]` if chain is empty.
function Chain:lastOrNil()
    return self._xt:last()
end

--- Returns the last element as `value, [key, index]`, or `dv, [dk, di]` if chain is empty.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The last element as `value, [key, index]`, or `dv, [dk, di]` if chain is empty.
function Chain:lastOrElse(dv, dk, di)
    asserts.if_present_then.is_integer(di)
    return util._orElse(dv, dk, di, self._xt.last, self._xt)
end

--- Returns the last element as `value, [key, index]`, or throws an error if the chain is empty.
--- @param msg string optional - Custom error message.
--- @return any The last element as `value, [key, index]`.
function Chain:lastOrError(msg)
    msg = tostring(msg or "lastOrError(..) failed: chain is empty") -- todo! make it all `tostring(..)`
    return util._orError(msg, self._xt.last, self._xt)
end

function Chain:luaSlice(pStart, pEnd, pStep)
    return Chain.new(slice(self._xt, pStart, pEnd, pStep, 1))
end

--- Maps elements using mapping function, returning a new Chain.
--- @param mapper function The mapping function `function(value, [key, index])`.
--- @return Chain A new Chain containing mapped elements.
function Chain:map(mapper)
    asserts.is_function(mapper)
    return Chain.new(self._xt:map(mapper))
end

-- todo! rename to `mapKeyValueToFields`
--- Transforms a map-like collection into a sequence of tables with specified field names.
--- For each key-value pair in the collection, creates a new table with two fields:
--- one containing the key and one containing the value.
---
--- Example:
--- ```
--- local data = {
---   Alice   = 20,
---   Bob     = 25,
---   Charlie = 30
--- }
---
--- chain(data):mapEntryToFields("name", "age"):toList()
---
--- {
---   Alice   = { name = "Alice",   age = 20 },
---   Bob     = { name = "Bob",     age = 25 },
---   Charlie = { name = "Charlie", age = 30 }
--- }
--- ```
---
--- @param fieldKey string Field name to store the original key
--- @param fieldValue string Field name to store the original value
--- @return Chain A new Chain containing a sequence of tables with the specified fields
function Chain:mapEntryToFields(fieldKey, fieldValue) -- todo! rename
    asserts.is_non_empty_string(fieldKey)
    asserts.is_non_empty_string(fieldValue)
    local newXt = xtable.new()
    for _, nk, v in self._xt:trios() do
        newXt:insert(nk, {
            [fieldKey] = nk,
            [fieldValue] = v
        })
    end
    return Chain.new(newXt)
end

--- Maps underlying value-tables to shallow copies of themselves.
--- Non-table values are preserved as-is.
--- @return Chain A new Chain object with shallow copies of values that are tables.
function Chain:shallowCopies()
    return Chain.new(self._xt:map(function(v)
        return util.shallowCopy(v)
    end))
end

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

--- Creates a map by taking each value-table element, using the value of `fieldName` as the new key,
--- and removes that field from the value-table in the resulting map.
--- Skips non-table elements, or table elements missing `fieldName`.
--- In case of duplicate keys, the first occurrence is preserved.
---
--- Example:
--- ```
--- local data = {
---   {role = "admin", name = "Alice"},
---   {role = "user",  name = "Bob"},
---   {role = "guest", name = "Charlie"}
--- }
---
--- local result = chain(data):moveFieldToKey("role"):toList()
---
--- result == {
---   admin = {name = "Alice"},
---   user  = {name = "Bob"},
---   guest = {name = "Charlie"}
--- }
--- ```
---
--- @param fieldName string The field whose value will become the map key.
--- @return Chain A new Chain containing a map, keyed by fieldName, without that field in each value.
function Chain:moveFieldToKey(fieldName)
    assert(type(fieldName) == "string" and #fieldName > 0,
            "Chain:moveFieldToKey: fieldName must be a non-empty string.")
    local newColl = {}
    for _, valueElement in self._xt:ipairs() do
        if type(valueElement) == "table" then
            local keyVal = valueElement[fieldName]
            if keyVal ~= nil and newColl[keyVal] == nil then
                local newValueElement = util.shallowCopy(valueElement)
                newValueElement[fieldName] = nil  -- remove the field from the new table
                newColl[keyVal] = newValueElement
            end
        end
    end
    return Chain.new(newColl)
end

--- Iterates underlying collection (expected map-like). For each entry,
--- if value is a table, adds original key to value-table under `fieldName`.
--- Returns new chain of these modified values as a sequence.
---
--- Example:
--- ```
--- local data = {
---   admin = {name = "Alice",   level = 10},
---   user  = {name = "Bob",     level = 5},
---   guest = {name = "Charlie", level = 1}
--- }
---
--- local result = chain(data):moveKeyToField("role"):toList()
---
--- result == {
---   {name = "Alice",   level = 10, role = "admin"},
---   {name = "Bob",     level = 5,  role = "user"},
---   {name = "Charlie", level = 1,  role = "guest"}
--- }
--- ```
---
--- @param fieldName string Name of the field to store the original key.
--- @return Chain A new Chain where elements (if tables) have original key added, transformed to a sequence.
function Chain:moveKeyToField(fieldName)
    asserts.is_non_empty_string(fieldName)
    local newColl = {}
    for key, valueElement in pairs(self) do
        if type(valueElement) == "table" then
            local newValueElement = util.shallowCopy(valueElement)
            newValueElement[fieldName] = key
            table.insert(newColl, newValueElement)
        else
            table.insert(newColl, valueElement)
        end
    end
    return Chain.new(newColl)
end

--- Sorts chain ascending, using natural order with stable sorting.
--- @return Chain A new Chain with sorted elements.
function Chain:order()
    local indexed = {}
    for idx, k, v in self._xt:trios() do
        table.insert(indexed, {idx = idx, k = k, v = v})
    end
    table.sort(indexed, function(a, b)
        if a.v == b.v then
            return a.idx < b.idx
        else
            return a.v < b.v
        end
    end)
    local newXt = xtable.new()
    for _, trio in ipairs(indexed) do
        newXt:insert(trio.k, trio.v)
    end
    return Chain.new(newXt)
end

-- Builds a stable, multi-criterion comparison for ascending/descending.
-- Each entry in self._sortFunctions is { selector=<fn>, direction="asc"|"desc" }.
local function stableMultiCompare(sortFunctions)
    return function(a, b)
        for _, criteria in ipairs(sortFunctions) do
            local left = criteria.selector(a.value)
            local right = criteria.selector(b.value)

            if left < right then
                return criteria.direction == "asc"
            elseif left > right then
                return criteria.direction == "desc"
            end
            -- If equal, fall through to next criterion
        end
        -- All criteria equal, preserve original order
        return a.index < b.index
    end
end

local function performStableSort(chain)
    local indexed = {}
    for i, v in chain._xt:ipairs() do
        table.insert(indexed, { value = v, index = i })
    end
    table.sort(indexed, stableMultiCompare(chain._sortFunctions))

    local newXt = xtable.new()
    for _, item in ipairs(indexed) do
        newXt:insert(item.index, item.value)
    end
    local newChain = Chain.new(newXt)
    newChain._sortFunctions = chain._sortFunctions
    return newChain
end

--- Sorts chain ascending, using `selector(value)` for sort key with stable sorting.
--- @param selector function Function `function(value)` to extract sort key.
--- @return Chain A new Chain with sorted elements.
function Chain:orderBy(selector)
    asserts.is_function(selector)
    -- Reset sort functions, begin new chain
    self._sortFunctions = {
        { selector = selector, direction = "asc" }
    }
    return performStableSort(self)
end

--- Sorts chain descending, using `selector(value)` for sort key with stable sorting.
--- @param selector function Function `function(value)` to extract sort key.
--- @return Chain A new Chain with sorted elements.
function Chain:orderByDesc(selector)
    asserts.is_function(selector)
    -- Reset sort functions, begin new chain
    self._sortFunctions = {
        { selector = selector, direction = "desc" }
    }
    return performStableSort(self)
end

--- Adds an ascending sort criterion, preserving earlier criteria via stable sorting.
--- Sorts chain ascending, using `selector(value)` for the additional sort key.
--- @param selector function Function `function(value)` to extract sort key.
--- @return Chain The same Chain instance, re-sorted with the new criterion.
function Chain:thenBy(selector)
    asserts.is_function(selector)
    if not self._sortFunctions then
        error("Cannot call thenBy(..) without calling orderBy(..) or orderByDesc(..) first.")
    end
    table.insert(self._sortFunctions, { selector = selector, direction = "asc" })
    return performStableSort(self)
end

--- Adds a descending sort criterion, preserving earlier criteria via stable sorting.
--- Sorts chain descending, using `selector(value)` for the additional sort key.
--- @param selector function Function `function(value)` to extract sort key.
--- @return Chain The same Chain instance, re-sorted with the new criterion.
function Chain:thenByDesc(selector)
    asserts.is_function(selector)
    if not self._sortFunctions then
        error("Cannot call thenByDesc(..) without calling orderBy(..) or orderByDesc(..) first.")
    end
    table.insert(self._sortFunctions, { selector = selector, direction = "desc" })
    return performStableSort(self)
end

--- Calculates the total number of pages required to display all items in the chain,
--- given a number of items per page. This is a terminal operation.
--- @param itemsPerPage number integer - The number of items to display on each page.
--- @return number The total number of pages. Returns 0 if itemsPerPage <= 0 or chain is empty.
function Chain:pageCount(itemsPerPage)
    asserts.is_integer(itemsPerPage)
    if itemsPerPage <= 0 then
        return 0
    end
    local len = #self._xt
    if len == 0 then
        return 0
    end
    return math.ceil(len / itemsPerPage)
end

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

function Chain:pySlice(pStart, pEnd, pStep)
    return Chain.new(slice(self._xt, pStart, pEnd, pStep, 0))
end

--- Reduces chain elements to a single value using `reducer(accumulator, value)`.
--- Note: will return `nil` if executed on an empty collection with no `initVal`.
--- @param reducer function The reducing function `function(accumulator, value)`.
--- @param initValue any optional - Initial accumulator value.
--- @return any The reduced value.
function Chain:reduce(reducer, initValue)
    asserts.is_function(reducer)
    return self._xt:reduce(reducer, initValue)
end

--- For each table element in the chain, creates a new table with specified fields renamed.
--- Other fields are preserved.
--- If an element is array-table or not a table - it is passed through unchanged.
--- If an old field name in the renameMap does not exist in an element, it is ignored.
--- Numeric-keyed fields could not be renamed.
--- @param renameMap table A map where `key` is the old field name and `value` is the new field name.
---                        Example: `{ oldName = "newName", anotherOld = "anotherNew" }`
--- @return Chain A new Chain where table elements have specified fields renamed.
function Chain:renameFields(renameMap)
    asserts.is_table(renameMap)
    local newColl = {}
    for _, element in self._xt:ipairs() do
        if type(element) ~= "table" then
            table.insert(newColl, element)
        elseif util.isArray(element) then
            local newElement = {}
            for i = 1, #element do
                newElement[i] = element[i]
            end
            for k, v in pairs(element) do
                if type(k) == "string" then
                    local newKey = renameMap[k] or k
                    newElement[newKey] = v
                end
            end
            table.insert(newColl, newElement)
        else
            local newElement = {}
            for k, v in pairs(element) do
                if type(k) == "string" then
                    local newKey = renameMap[k] or k
                    newElement[newKey] = v
                else
                    newElement[k] = v
                end
            end
            table.insert(newColl, newElement)
        end
    end
    return Chain.new(newColl)
end

--- For each table element in the chain, creates a new table containing only the specified fields.
--- If a specified field does not exist in an element, it's omitted in the new table.
--- If an element is array-table or not a table - it is passed through unchanged.
--- Numeric-keyed fields could not be selected.
--- @param fieldsToSelect table A sequence table of string field names to select.
--- @return Chain A new Chain where table elements have only the selected fields.
function Chain:selectFields(fieldsToSelect)
    asserts.is_table(fieldsToSelect)
    local coll = {}
    for _, element in self._xt:ipairs() do
        if type(element) ~= "table" or util.isArray(element) then
            table.insert(coll, element)
        else
            local newElement = {}
            for _, fieldName in ipairs(fieldsToSelect) do
                if type(fieldName) == "string" and element[fieldName] ~= nil then
                    newElement[fieldName] = element[fieldName]
                end
            end
            table.insert(coll, newElement)
        end
    end
    return Chain.new(coll)
end

--- Returns the element if chain has one element, or `nil` if zero or more than one elements.
--- @return any The single element, or `nil`.
function Chain:singleOrNil()
    return self._xt:single()
end

--- Returns the single element as `value, [key, index]`, or `dv, [dk, di]` if zero or more than one elements.
--- @param dv any The default value.
--- @param dk any The default key.
--- @param di any The default index.
--- @return any The single element as `value, [key, index]`, or `dv, [dk, di]` if zero or more than one elements.
function Chain:singleOrElse(dv, dk, di)
    asserts.if_present_then.is_integer(di)
    return util._orElse(dv, dk, di, self._xt.single, self._xt)
end

--- Returns the single element as `value, [key, index]`, or throws an error if zero or more than one elements.
--- @param msg string optional - Custom error message.
--- @return any The single element as `value, [key, index]`.
function Chain:singleOrError(msg)
    local cnt = #self._xt
    local m = msg or "singleOrError failed: Expected single element."
    local ms = string.format("%s (Found %d elements)", m, cnt)
    return util._orError(ms, self._xt.single, self._xt)
end

--- Skips first `n` elements, returns new chain.
--- @param n number Number of elements to skip.
--- @return Chain A new Chain object.
function Chain:skip(n)
    asserts.is_integer(n)
    return Chain.new(self._xt:skip(n))
end

--- Takes first `n` elements, returns new chain.
--- @param n number Number of elements to take.
--- @return Chain A new Chain object.
function Chain:take(n)
    asserts.is_integer(n)
    return Chain.new(self._xt:take(n))
end

--- Returns the underlying Lua collection as sequence. This is a terminal operation.
--- @return table The raw Lua collection as sequence.
function Chain:toList()
    return self._xt:toList()
end

--- Returns the underlying Lua collection as map. This is a terminal operation.
--- @return table The raw Lua collection as map.
function Chain:toMap()
    return self._xt:toMap()
end

--- todo! docs and specs
function Chain:trios()
    return self._xt:trios()
end

--- Returns new chain of all values from `pairs()` iteration. Order not guaranteed for maps.
--- @return Chain A new Chain object containing values.
function Chain:values()
    local newXt = xtable.new()
    for ik, _, v in self._xt:trios() do
        newXt:insert(ik, v)
    end
    return Chain.new(newXt)
end

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

local chain = {}

--- Creates a Chain from a sequence of key-value pairs
---@param ps any[] Sequence of alternating keys and values
---@return Chain
function chain.fromPairs(ps)
    local newXt = xtable.new()
    local key
    local isValue = false
    for _, it in ipairs(ps) do
        if isValue then
            newXt:insert(key, it)
        else
            key = it
        end
        isValue = not isValue
    end
    return Chain.new(newXt)
end

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

--- Aliases
Chain.at       = Chain.getAtPositionOrNil
Chain.each     = Chain.forEach
Chain.foreach  = Chain.forEach
Chain.find     = Chain.findFirstOrNil
Chain.findLast = Chain.findLastOrNil
Chain.first    = Chain.firstOrNil
Chain.get      = Chain.getByKeyOrNil
Chain.last     = Chain.lastOrNil
Chain.len      = Chain.count
Chain.length   = Chain.count
Chain.single   = Chain.singleOrNil
Chain.size     = Chain.count
Chain.slice    = Chain.luaSlice
Chain.unique   = Chain.distinct
Chain.val      = Chain.getByValueOrNil
--- / Aliases

return _chain(chain)
