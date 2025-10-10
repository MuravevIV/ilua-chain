require("mobdebug_mod_1").start("172.17.0.1", 8172)

lust = require 'tests/lust'

for _, fn in pairs({'describe', 'it', 'test', 'expect', 'spy', 'before', 'after'}) do
  _G[fn] = lust[fn]
end

-- helper function to safely accumulate errors which will be displayed when done testing
function tryCall(fn, errorsAccumulator)
  local errNum = #errorsAccumulator

  xpcall(fn, function (err)
    table.insert(errorsAccumulator, err)
  end)

  return #errorsAccumulator == errNum
end

function throwErrorsIfAny(errorsAccumulator)
  if #errorsAccumulator > 0 then
    error(table.concat(errorsAccumulator, '\n\t' .. string.rep('\t', lust.level)))
  end
end

table.insert(lust.paths['to'], 'produce')

if arg[1] then
  arg[1] = arg[1]:gsub('^(tests/)', ''):gsub('%.lua$', '')
  dofile('tests/' .. arg[1] .. '.lua')
else
  local files = {
    'spec/xtable_spec',
    'spec/util_spec',
    'spec/extensions/range_spec',
    'spec/extensions/fromPairs_spec',
    'spec/operators/all_spec',
    'spec/operators/any_spec',
    'spec/operators/assertCountAtLeast_spec',
    'spec/operators/assertCountAtMost_spec',
    'spec/operators/assertCountEquals_spec',
    'spec/operators/assertIsEmpty_spec',
    'spec/operators/assertIsNotEmpty_spec',
    'spec/operators/assertSingle_spec',
    'spec/operators/at_spec',
    'spec/operators/copyFieldToKey_spec',
    'spec/operators/copyKeyToField_spec',
    'spec/operators/count_spec',
    'spec/operators/count_spec',
    'spec/operators/dropFields_spec',
    'spec/operators/filter_spec',
    'spec/operators/filterNot_spec',
    'spec/operators/find_spec',
    'spec/operators/findLast_spec',
    'spec/operators/findFirstOrElse_spec',
    'spec/operators/findFirstOrError_spec',
    'spec/operators/findFirstOrNil_spec',
    'spec/operators/findLastOrElse_spec',
    'spec/operators/findLastOrError_spec',
    'spec/operators/findLastOrNil_spec',
    'spec/operators/first_spec',
    'spec/operators/firstOrElse_spec',
    'spec/operators/firstOrError_spec',
    'spec/operators/firstOrNil_spec',
    'spec/operators/flatMap_spec',
    'spec/operators/forEach_spec',
    'spec/operators/get_spec',
    'spec/operators/getByKeyOrNil_spec',
    'spec/operators/groupBy_spec',
    'spec/operators/isEmpty_spec',
    'spec/operators/isNotEmpty_spec',
    'spec/operators/keys_spec',
    'spec/operators/last_spec',
    'spec/operators/lastOrElse_spec',
    'spec/operators/lastOrError_spec',
    'spec/operators/lastOrNil_spec',
    'spec/operators/map_spec',
    'spec/operators/mapEntryToFields_spec',
    'spec/operators/shallowCopies_spec',
    'spec/operators/moveFieldToKey_spec',
    'spec/operators/moveKeyToField_spec',
    'spec/operators/order_spec',
    'spec/operators/orderBy_group_spec',
    'spec/operators/pageCount_spec',
    'spec/operators/pageSlice_spec',
    'spec/operators/reduce_spec',
    'spec/operators/renameFields_spec',
    'spec/operators/selectFields_spec',
    'spec/operators/single_spec',
    'spec/operators/singleOrElse_spec',
    'spec/operators/singleOrError_spec',
    'spec/operators/singleOrNil_spec',
    'spec/operators/skip_spec',
    'spec/operators/take_spec',
    'spec/operators/val_spec',
    'spec/operators/values_spec',
    'spec/operators/_playground_spec',
  }

  for i, file in ipairs(files) do
    dofile('tests/' .. file .. '.lua')
    if next(files, i) then
      -- print()
    end
  end
end

local red = string.char(27) .. '[31m'
local green = string.char(27) .. '[32m'
local normal = string.char(27) .. '[0m'

if lust.errors > 0 then
  io.write(red .. lust.errors .. normal .. ' failed, ')
end

print(green .. lust.passes .. normal .. ' passed')

if lust.errors > 0 then os.exit(1) end
