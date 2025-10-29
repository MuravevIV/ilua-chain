--[[
Implements Python-like slice functionality for Lua tables (arrays).

Args:
  tbl (table): The input array-like table to slice.
  start (number | nil): The starting index of the slice.
  end_param (number | nil): The ending index of the slice (exclusive, following Python's model).
  step_param (number | nil): The step of the slice.
  shiftPos (number): Determines indexing convention for `start` and `end_param`:
    - 0: Python-style 0-based indexing. Negative indices count from the end
         (e.g., -1 is the last element, corresponding to 0-based index #tbl-1).
    - 1: Lua-style 1-based indexing. Negative indices count from the end
         (e.g., -1 maps to table index #tbl, -2 to #tbl-1).

Returns:
  A new table containing the sliced elements.

Behavior based on Python's slice semantics:
- If `start` is `nil`, it defaults appropriately based on `step_param` (0 for positive step, #tbl-1 for negative step, 0-based).
- If `end_param` is `nil`, it defaults appropriately based on `step_param` (#tbl for positive step, -1 (conceptual "before start") for negative step, 0-based).
- If `step_param` is `nil`, it defaults to 1.
- `step_param` cannot be 0; will raise an error.
- Indices are normalized and clamped to table bounds to mimic Python's behavior.

Conversion for shiftPos=1 (Lua 1-based input `s_lua`, `e_lua`):
- `start`:
  - If `s_lua` > 0: Python-equivalent 0-based start is `s_lua - 1`.
  - If `s_lua` <= 0: Python-equivalent 0-based start is `#tbl + s_lua`.
    (e.g., Lua `start=-1` -> `py_start = #tbl-1`)
- `end_param` (Python slice end is exclusive):
  - If `e_lua` > 0: Python-equivalent 0-based end is `e_lua`.
    (e.g., Lua `end_param=3` means slice includes 1-based indices 1, 2. If start=1,
     `py_start=0`, `py_end=3`. Iterates 0-based 0, 1, 2. Accesses tbl[1], tbl[2], tbl[3].)
  - If `e_lua` <= 0: Python-equivalent 0-based end is `#tbl + e_lua`.
    (e.g., Lua `end_param=-1` for `tbl` of size N -> `py_end = N-1`. `arr[0:N-1]` in Python.)

Examples:
  local t = {10,20,30,40,50} -- #t = 5
  luaSlice(t, 0, nil, nil, 0) == {10,20,30,40,50} -- Python: t[:]
  luaSlice(t, 1, 3, nil, 0) == {20,30}           -- Python: t[1:3]
  luaSlice(t, nil, nil, 2, 0) == {10,30,50}      -- Python: t[::2]
  luaSlice(t, nil, nil, -1, 0) == {50,40,30,20,10} -- Python: t[::-1]
  luaSlice(t, 3, 0, -1, 0) == {40,30,20}         -- Python: t[3:0:-1] (0-based start=3, 0-based end=0)

  luaSlice(t, 1, nil, nil, 1) == {10,20,30,40,50} -- Lua: from 1st to end (py_start=0, py_end=5)
  luaSlice(t, 2, 4, nil, 1) == {20,30}           -- Lua: elements at t[2],t[3]. (py_start=1, py_end=4 -> norm_end=3. Iterates 0-based 1,2)
                                                 -- No, py_end=4. norm_end=4. Iterates 0-based 1,2,3 -> tbl[2],tbl[3],tbl[4].
                                                 -- Lua indices 2,3,4. tbl[2],tbl[3],tbl[4]. {20,30,40}
                                                 -- This differs from example comment above. Let's trace:
                                                 -- luaSlice(t, 2, 4, nil, 1)
                                                 -- n=5. start=2, end_param=4, step_param=nil, shiftPos=1
                                                 -- py_start: start(2)>0 -> 2-1 = 1.
                                                 -- py_end: end_param(4)>0 -> 4.
                                                 -- _normalize_indices(5, 1, 4, nil) -> norm_start=1, norm_stop=4, norm_step=1
                                                 -- Loop current_0_based_idx = 1, 2, 3.
                                                 -- result gets tbl[1+1], tbl[2+1], tbl[3+1] = tbl[2], tbl[3], tbl[4].
                                                 -- Output: {20,30,40}. The example comment was incorrect. Updated.

  luaSlice(t, 1, -1, nil, 1) == {10,20,30,40}    -- Lua: t[1] up to t[#t-1] (py_start=0, py_end=#t-1=4)
  luaSlice(t, 4, 1, -1, 1) == {40,30,20}         -- Lua: t[4],t[3],t[2] (py_start=3, py_end=1. Iterates 0-based 3,2)
]]

local function _normalize_indices(length, s_orig, e_orig, p_orig)
  -- This internal helper calculates the final 0-based start (inclusive),
  -- end (exclusive), and step values for iteration, mimicking Python's
  -- slice.indices(length) behavior.

  local step
  if p_orig == nil then
    step = 1
  else
    step = p_orig
  end

  if step == 0 then
    -- Level 2 reports error from the perspective of luaSlice's caller.
    error("luaSlice: slice step_param cannot be zero", 2)
  end

  local start_idx, end_idx

  if step > 0 then
    -- Handle start for step > 0
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
    -- Handle start for step < 0
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

function luaSlice(tbl, start, end_param, step_param, shiftPos)
  if type(tbl) ~= "table" then
    error("luaSlice: input 'tbl' must be a table", 2)
  end
  if shiftPos ~= 0 and shiftPos ~= 1 then
    error("luaSlice: 'shiftPos' must be 0 or 1", 2)
  end

  local n = #tbl
  local py_start, py_end -- These will be nil or 0-based integer indices

  -- Convert input start/end to 0-based Python-style nil-or-integer values.
  -- `step_param` is passed directly to _normalize_indices.
  if shiftPos == 1 then -- Lua 1-based input
    if start ~= nil then
      if type(start) ~= "number" then error("luaSlice: 'start' must be a number or nil for shiftPos=1", 2) end
      if start > 0 then
        py_start = start - 1
      else -- start <= 0 (Lua negative indices: -1 is #tbl, etc.)
        py_start = n + start
      end
    end -- else py_start remains nil

    if end_param ~= nil then
      if type(end_param) ~= "number" then error("luaSlice: 'end_param' must be a number or nil for shiftPos=1", 2) end
      if end_param > 0 then
        -- Lua end X (1-based) means up to element X.
        -- Python slice end Y (0-based, exclusive) for element at 0-based index X-1 must be X.
        py_end = end_param
      else -- end_param <= 0 (Lua negative indices)
        py_end = n + end_param
      end
    end -- else py_end remains nil
  else -- Python 0-based input
    if start ~= nil and type(start) ~= "number" then error("luaSlice: 'start' must be a number or nil for shiftPos=0", 2) end
    if end_param ~= nil and type(end_param) ~= "number" then error("luaSlice: 'end_param' must be a number or nil for shiftPos=0", 2) end
    py_start = start
    py_end = end_param
  end

  if step_param ~= nil and type(step_param) ~= "number" then error("luaSlice: 'step_param' must be a number or nil", 2) end

  local norm_start, norm_stop, norm_step = _normalize_indices(n, py_start, py_end, step_param)

  local result = {}
  local current_0_based_idx -- Current 0-based index for iteration
  local result_insert_idx = 1 -- 1-based index for inserting into Lua result table

  if norm_step > 0 then
    current_0_based_idx = norm_start
    while current_0_based_idx < norm_stop do
      -- Access tbl using 1-based index from 0-based current_0_based_idx
      result[result_insert_idx] = tbl[current_0_based_idx + 1]
      result_insert_idx = result_insert_idx + 1
      current_0_based_idx = current_0_based_idx + norm_step
    end
  elseif norm_step < 0 then
    current_0_based_idx = norm_start
    while current_0_based_idx > norm_stop do -- Note: comparison is '>' for negative step
      result[result_insert_idx] = tbl[current_0_based_idx + 1]
      result_insert_idx = result_insert_idx + 1
      current_0_based_idx = current_0_based_idx + norm_step
    end
  end
  -- If norm_step == 0, _normalize_indices would have already raised an error.

  return result
end

-- To make it runnable/testable directly or as a module:
-- Example usage (uncomment to test):
-- local function print_table(t, name)
--     name = name or "Table"
--     local parts = {}
--     for i = 1, #t do
--         parts[i] = tostring(t[i])
--     end
--     print(name .. ": {" .. table.concat(parts, ", ") .. "}")
-- end

-- local t = {10, 20, 30, 40, 50}
-- print_table(luaSlice(t, 0, nil, nil, 0), "t[:] (0-based)") -- {10,20,30,40,50}
-- print_table(luaSlice(t, 1, 3, nil, 0), "t[1:3] (0-based)") -- {20,30}
-- print_table(luaSlice(t, nil, nil, 2, 0), "t[::2] (0-based)") -- {10,30,50}
-- print_table(luaSlice(t, nil, nil, -1, 0), "t[::-1] (0-based)") -- {50,40,30,20,10}
-- print_table(luaSlice(t, 3, 0, -1, 0), "t[3:0:-1] (0-based)") -- {40,30,20}
-- print_table(luaSlice(t, -1, -4, -1, 0), "t[-1:-4:-1] (0-based)") -- {50,40,30}

-- print_table(luaSlice(t, 1, nil, nil, 1), "t[1:] (1-based)") -- {10,20,30,40,50}
-- print_table(luaSlice(t, 2, 4, nil, 1), "t[2:4] (1-based)") -- {20,30,40} -- Elements at Lua indices 2,3,4
-- print_table(luaSlice(t, 1, -1, nil, 1), "t[1:-1] (1-based)") -- {10,20,30,40} -- Lua indices 1 up to (#t-1)
-- print_table(luaSlice(t, 4, 1, -1, 1), "t[4:1:-1] (1-based)") -- {40,30,20} -- Lua indices 4,3,2

-- local empty_t = {}
-- print_table(luaSlice(empty_t, nil, nil, nil, 0), "empty_t[:] (0-based)") -- {}
-- print_table(luaSlice(empty_t, nil, nil, -1, 0), "empty_t[::-1] (0-based)") -- {}

-- Test error cases
-- pcall(function() luaSlice(t, nil, nil, 0, 0) end) -- step 0
-- pcall(function() luaSlice("not a table", nil, nil, nil, 0) end) -- not a table
-- pcall(function() luaSlice(t, nil, nil, nil, 2) end) -- invalid shiftPos
-- pcall(function() luaSlice(t, "a", nil, nil, 0) end) -- invalid start type

-- If used as a module:
-- return { luaSlice = luaSlice }
