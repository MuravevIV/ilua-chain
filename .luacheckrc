-- .luacheckrc

-- Define globals that are common in Busted test files
-- so Luacheck doesn't warn about them being undefined.
globals = {
  "describe",   -- Busted: main function for grouping tests
  "it",         -- Busted: defines an individual test case
  "before_each",-- Busted: runs before each 'it' in a 'describe'
  "after_each", -- Busted: runs after each 'it' in a 'describe'
  "pending",    -- Busted: marks a test as pending
  "assert",     -- Busted's default assertion library (or can be luassert)
  -- Add any other globals your test setup might introduce, e.g., if
  -- you assign test helper functions or libraries to global variables
  -- in test_helper.lua.
  -- "my_custom_test_helper"
}

-- Configuration for ignoring specific warnings.
--
-- 212: unused argument.
-- It's common in test stubs or Busted callbacks (like 'before_each')
-- to have arguments that are not always used, especially the placeholder '_'.
--
-- Example:
-- ignore = {
--    "212/_" -- Ignore unused argument specifically named '_'
-- }
--
-- You can be more or less specific.
-- To ignore all unused arguments in all files (less recommended):
-- ignore = { "212" }
--
-- To ignore unused arguments in files within the 'tests/' directory:
-- files["tests/"]["ignore"] = { "212" }

-- For this project, a common pattern is unused 'value' or 'index' in filter/map
-- predicates/mappers if the test doesn't use them, or '_' in callbacks.
-- Let's allow unused arguments named '_'.
ignore = {
    "212/_"
}

-- If your 'chain.lua' module is intended to be used as a global in some
-- contexts (though `local chain = require("chain")` is generally preferred),
-- you might want to declare it here to avoid 'undefined global variable' warnings
-- when checking individual files that assume its presence.
-- However, for a library, it's usually better to require it explicitly.
--
-- read_globals = {
--   "chain" -- If 'chain' was expected to be a predefined global
-- }

-- You can also set per-file or per-directory configurations.
-- For example, if your test files have different global expectations:
--
-- files["tests/spec/"] = {
--   globals = {
--     "describe", "it", "assert", "chain_module_being_tested"
--   }
-- }