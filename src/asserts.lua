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
