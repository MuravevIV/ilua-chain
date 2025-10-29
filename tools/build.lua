--- Horrible script to concatenate everything in /src into a single chain.lua file.
-- @usage lua tools/build.lua [distribution=base]
-- @arg {string='base'} distribution - Type of distribution to build, either 'base' or 'luvit'.

local files = {
  { file = 'src/serpent.lua', as = 'serpent' },
  { file = 'src/util.lua', as = 'util' },
  { file = 'src/asserts.lua', as = 'asserts' },
  { file = 'src/xtable.lua', as = 'xtable' },
  { file = 'src/slice.lua', as = 'slice' },
  'src/chain_class.lua',
  'src/operators/all.lua',
  'src/operators/any.lua',
  'src/operators/assertCountAtLeast.lua',
  'src/operators/assertCountAtMost.lua',
  'src/operators/assertCountEquals.lua',
  'src/operators/assertEquals.lua',
  'src/operators/assertIsEmpty.lua',
  'src/operators/assertIsNotEmpty.lua',
  'src/operators/assertMultiple.lua',
  'src/operators/assertSingle.lua',
  'src/operators/copyFieldToKey.lua',
  'src/operators/copyKeyToField.lua',
  'src/operators/count.lua',
  'src/operators/decapsule.lua',
  'src/operators/distinct.lua',
  'src/operators/dropFields.lua',
  'src/operators/encapsule.lua',
  'src/operators/filter.lua',
  'src/operators/filterNot.lua',
  'src/operators/filterNotNil.lua',
  'src/operators/findFirst_.lua',
  'src/operators/findLast_.lua',
  'src/operators/first_.lua',
  'src/operators/flatMap.lua',
  'src/operators/forEach.lua',
  'src/operators/forSelf.lua',
  'src/operators/getAtPositionOrNil.lua',
  'src/operators/getByKeyOrNil.lua',
  'src/operators/getByValueOrNil.lua',
  'src/operators/groupBy.lua',
  'src/operators/isEmpty.lua',
  'src/operators/isNotEmpty.lua',
  'src/operators/join_.lua',
  'src/operators/keys.lua',
  'src/operators/last_.lua',
  'src/operators/luaSlice.lua',
  'src/operators/map.lua',
  'src/operators/mapEntryToFields.lua',
  'src/operators/mergeByKeyInto.lua',
  'src/operators/mkString.lua',
  'src/operators/moveFieldToKey.lua',
  'src/operators/moveKeyToField.lua',
  'src/operators/order.lua',
  'src/operators/orderBy_group.lua',
  'src/operators/pageCount.lua',
  'src/operators/pageSlice.lua',
  'src/operators/pySlice.lua',
  'src/operators/reduce.lua',
  'src/operators/renameFields.lua',
  'src/operators/selectFields.lua',
  'src/operators/shallowCopies.lua',
  'src/operators/single_.lua',
  'src/operators/skip.lua',
  'src/operators/take.lua',
  'src/operators/toList.lua',
  'src/operators/toMap.lua',
  'src/operators/trios.lua',
  'src/operators/values.lua',
  'src/operators/_after.lua',
  'src/extensions/_before.lua',
  'src/extensions/fromPairs.lua',
  'src/extensions/range.lua',
  'src/aliases.lua',
}

local header = [[
-- ilua-chain v0.0.1
-- https://github.com/MuravevIV/ilua-chain
-- MIT License

]]

local exports = [[
exports.name = 'MuravevIV/ilua-chain'
exports.version = '0.0.3'
exports.description = 'Reactive Extensions for Lua'
exports.license = 'MIT'
exports.author = { url = 'https://github.com/MuravevIV' }
exports.homepage = 'https://github.com/MuravevIV/ilua-chain'

]]

local footer = [[return _chain(chain)
]]

local output = ''

local function readFile(fileName)
  local file = io.open(fileName)
  if not file then
    error('error opening "' .. fileName .. '"')
  end
  local str = file:read('*all')
  file:close()
  return str
end

local function stripAgency(str)
  str = '\n' .. str .. '\n'
  str = str:gsub('\n(local[^\n]+require.[^\n]+)', '')
  str = str:gsub('\n(return[^\n]+)', '')
  return str:gsub('^%s+', ''):gsub('%s+$', '')
end

local function stripAgencyExceptReturn(str)
  str = '\n' .. str .. '\n'
  str = str:gsub('\n(local[^\n]+require.[^\n]+)', '')
  return str:gsub('^%s+', ''):gsub('%s+$', '')
end

local function addLeftPadding(str, pad)
  local pStr = string.rep(" ", pad)
  return pStr .. str:gsub("\n", "\n" .. pStr)
end

for _, f in ipairs(files) do
  local str
  if type(f) == "table" then
    str = readFile(f.file)
    str = stripAgencyExceptReturn(str)
    str = addLeftPadding(str, 4)
    str = "local " .. f.as .. " = (function()\n"
        .. str .. "\n"
        .. "end)()"
  else
    str = readFile(f)
    str = stripAgency(str)
  end

  output = output .. str .. '\n\n'
end

local distribution = arg[1] or 'base'
local destination, components

if distribution == 'base' then
  destination = 'chain.lua'
  components = { header, output, footer }
elseif distribution == 'luvit' then
  destination = 'ilua-chain-luvit.lua'
  components = { header, exports, output, footer }
else
  error('Invalid distribution specified.')
end

local file = io.open(destination, 'w')

if file then
  file:write(table.concat(components, ''))
  file:close()
end

print("tools/build.lua - done")
