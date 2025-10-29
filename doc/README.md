ilua-stream
===

- [Stream](#stream)
  - [all](#allpred
)
  - [any](#anypred
)
  - [assertCountAtLeast](#assertcountatleastn-msg
)
  - [assertCountAtMost](#assertcountatmostn-msg
)
  - [assertCountEquals](#assertcountequalsn-msg
)
  - [assertIsEmpty](#assertisemptymsg
)
  - [assertIsNotEmpty](#assertisnotemptymsg
)
  - [assertSingle](#assertsinglemsg
)
  - [collect](#collect)
  - [copyFieldToKey](#copyfieldtokeyfieldname
)
  - [copyKeyToField](#copykeytofieldfieldname
)
  - [count](#count
)
  - [dropFields](#dropfieldsfieldstodrop
)
  - [entries](#entries)
  - [filter](#filterpred)
  - [filterNot](#filternotpred)
  - [findFirstOrDefault](#findfirstordefaultpred-defaultval
)
  - [findFirstOrError](#findfirstorerrorpred-msg
)
  - [findFirstOrNil](#findfirstornilpred
)
  - [findLastOrDefault](#findlastordefaultpred-defaultval
)
  - [findLastOrError](#findlastorerrorpred-msg
)
  - [findLastOrNil](#findlastornilpred
)
  - [firstOrDefault](#firstordefaultdefaultval
)
  - [firstOrError](#firstorerrormsg
)
  - [firstOrNil](#firstornil
)
  - [flatMap](#flatmapmapper)
  - [forEach](#foreachactfunc
)
  - [isEmpty](#isempty
)
  - [isNotEmpty](#isnotempty
)
  - [keys](#keys
)
  - [lastOrDefault](#lastordefaultdefaultval
)
  - [lastOrError](#lastorerrormsg
)
  - [lastOrNil](#lastornil
)
  - [map](#mapmapper)
  - [mapEntryToFields](#mapentrytofieldsfieldkey-fieldvalue
)
  - [mapShallowCopy](#mapshallowcopy
)
  - [moveFieldToKey](#movefieldtokeyfieldname
)
  - [moveKeyToField](#movekeytofieldfieldname
)
  - [order](#order
)
  - [orderBy](#orderbyselector
)
  - [orderByDesc](#orderbydescselector
)
  - [thenBy](#thenbyselector
)
  - [thenByDesc](#thenbydescselector
)
  - [pageCount](#pagecountitemsperpage
)
  - [pageSlice](#pagesliceitemsperpage-pagenum
)
  - [reduce](#reducereducer-initval)
  - [renameFields](#renamefieldsrenamemap
)
  - [selectFields](#selectfieldsfieldstoselect
)
  - [singleOrDefault](#singleordefaultdefaultval
)
  - [singleOrError](#singleorerrormsg
)
  - [singleOrNil](#singleornil
)
  - [skip](#skipn
)
  - [take](#taken
)
  - [toMap](#tomapmapper)
  - [unique](#unique
)
  - [values](#values
)
  - [range](#rangestartnum-finishnum-stepnum
)

# Stream

---

#### `:all(pred)
`

Checks if all elements satisfy `pred(value, index)`. True if empty.

---

#### `:any(pred)
`

Checks if any element satisfies `pred(value, index)`.

---

#### `:assertCountAtLeast(n, msg)
`

Asserts that stream has at least `n` elements, throws assertion error if not. Returns `self`.

---

#### `:assertCountAtMost(n, msg)
`

Asserts that stream has at most `n` elements, throws assertion error if not. Returns `self`.

---

#### `:assertCountEquals(n, msg)
`

Asserts that stream has exactly `n` elements, throws assertion error if not. Returns `self`.

---

#### `:assertIsEmpty(msg)
`

Asserts that stream is empty, throws assertion error if it is not. Returns `self`.

---

#### `:assertIsNotEmpty(msg)
`

Asserts that stream is not empty, throws assertion error if it is. Returns `self`.

---

#### `:assertSingle(msg)
`

Asserts that stream has exactly one element, throws assertion error if not. Returns `self`.

---

#### `:collect()`

Returns the underlying Lua collection. This is a terminal operation.

---

#### `:copyFieldToKey(fieldName)
`

Creates a map by taking each value-table element, using the value of `fieldName` as the new key.
 Non-table elements are skipped. Table elements lacking `fieldName` are also skipped.
 In case of duplicate keys, the first occurrence takes precedence.
 --- Example:
 ```
 local data = {
 {role = "admin", name = "Alice"},
 {role = "user",  name = "Bob"},
 {role = "guest", name = "Charlie"}
 }
 --- local result = Stream.new(data):copyFieldToKey("role"):toList()
 --- result == {
 admin = {role = "admin", name = "Alice"},
 user  = {role = "user",  name = "Bob"},
 guest = {role = "guest", name = "Charlie"}
 }
 ```
 ---

---

#### `:copyKeyToField(fieldName)
`

Iterates underlying collection (expected map-like). For each entry,
 if value is a table, copies original key to value-table under `fieldName`.
 Replaces `fieldName` field if it exists for value-tables.
 Returns new stream of these modified values as a map.
 --- Example:
 ```
 local data = {
 admin = {name = "Alice",   level = 10},
 user  = {name = "Bob",     level = 5},
 guest = {name = "Charlie", level = 1}
 }
 --- local result = Stream.new(data):copyKeyToField("role"):toList()
 --- result == {
 admin = {name = "Alice",   level = 10, role = "admin"},
 user  = {name = "Bob",     level = 5,  role = "user"},
 guest = {name = "Charlie", level = 1,  role = "guest"}
 }
 ```
 ---

---

#### `:count()
`

Returns number of elements.

---

#### `:dropFields(fieldsToDrop)
`

For each table element in the stream, creates a new table excluding the specified fields.
 If an element is array-table or not a table - it is passed through unchanged.
 Numeric-keyed fields could not be dropped.

---

#### `:entries()`

Returns a new stream of `{ key = k, value = v }` from `pairs()` iteration. Order is not guaranteed for map-like inputs.

---

#### `:filter(pred)`

Filters the elements of the stream based on a predicate function. The predicate function receives `(value, index)`.

---

#### `:filterNot(pred)`

Filters the elements of the stream based on an inverse of a predicate function. The predicate function receives `(value, index)`.

---

#### `:findFirstOrDefault(pred, defaultVal)
`

Finds the first element satisfying `pred(value, index)`, or returns `defaultVal`.

---

#### `:findFirstOrError(pred, msg)
`

Finds the first element satisfying `pred(value, index)`, or throws an error.

---

#### `:findFirstOrNil(pred)
`

Finds the first element satisfying `pred(value, index)`, or returns `nil`.

---

#### `:findLastOrDefault(pred, defaultVal)
`

Finds the last element satisfying `pred(value, index)`, or returns `defaultVal`.

---

#### `:findLastOrError(pred, msg)
`

Finds the last element satisfying `pred(value, index)`, or throws an error.

---

#### `:findLastOrNil(pred)
`

Finds the last element satisfying `pred(value, index)`, or returns `nil`.

---

#### `:firstOrDefault(defaultVal)
`

Returns the first element of the stream, or a default value if the stream is empty.

---

#### `:firstOrError(msg)
`

Returns the first element of the stream, or throws an error if the stream is empty.

---

#### `:firstOrNil()
`

Returns the first element of the stream, or `nil` if the stream is empty.

---

#### `:flatMap(mapper)`

Maps elements using `mapper(value, index)` to tables, then flattens results.

---

#### `:forEach(actFunc)
`

Applies `actFn(value, index)` to each element for side-effects. Returns `self`.

---

#### `:isEmpty()
`

Checks if the stream is empty.

---

#### `:isNotEmpty()
`

Checks if the stream is not empty.

---

#### `:keys()
`

Returns new stream of all keys from `pairs()` iteration. Order not guaranteed for maps.

---

#### `:lastOrDefault(defaultVal)
`

Returns the last element of the stream, or a default value if the stream is empty.

---

#### `:lastOrError(msg)
`

Returns the last element of the stream, or throws an error if the stream is empty.

---

#### `:lastOrNil()
`

Returns the last element of the stream, or `nil` if the stream is empty.

---

#### `:map(mapper)`

Maps elements using `mapper(value, index)`, returning a new stream.

---

#### `:mapEntryToFields(fieldKey, fieldValue)
`

Transforms a map-like collection into a sequence of tables with specified field names.
 For each key-value pair in the collection, creates a new table with two fields:
 one containing the key and one containing the value.

---

#### `:mapShallowCopy()
`

Maps underlying value-tables to shallow copies of themselves.
 Non-table values are preserved as-is.

---

#### `:moveFieldToKey(fieldName)
`

Creates a map by taking each value-table element, using the value of `fieldName` as the new key,
 and removes that field from the value-table in the resulting map.
 Skips non-table elements, or table elements missing `fieldName`.
 In case of duplicate keys, the first occurrence is preserved.
 --- Example:
 ```
 local data = {
 {role = "admin", name = "Alice"},
 {role = "user",  name = "Bob"},
 {role = "guest", name = "Charlie"}
 }
 --- local result = Stream.new(data):moveFieldToKey("role"):toList()
 --- result == {
 admin = {name = "Alice"},
 user  = {name = "Bob"},
 guest = {name = "Charlie"}
 }
 ```
 ---

---

#### `:moveKeyToField(fieldName)
`

Iterates underlying collection (expected map-like). For each entry,
 if value is a table, adds original key to value-table under `fieldName`.
 Returns new stream of these modified values as a sequence.
 --- Example:
 ```
 local data = {
 admin = {name = "Alice",   level = 10},
 user  = {name = "Bob",     level = 5},
 guest = {name = "Charlie", level = 1}
 }
 --- local result = Stream.new(data):moveKeyToField("role"):toList()
 --- result == {
 {name = "Alice",   level = 10, role = "admin"},
 {name = "Bob",     level = 5,  role = "user"},
 {name = "Charlie", level = 1,  role = "guest"}
 }
 ```
 ---

---

#### `:order()
`

Sorts stream ascending, using natural order with stable sorting.

---

#### `:orderBy(selector)
`

Sorts stream ascending, using `selector(value)` for sort key with stable sorting.

---

#### `:orderByDesc(selector)
`

Sorts stream descending, using `selector(value)` for sort key with stable sorting.

---

#### `:thenBy(selector)
`

Adds an ascending sort criterion, preserving earlier criteria via stable sorting.
 Sorts stream ascending, using `selector(value)` for the additional sort key.

---

#### `:thenByDesc(selector)
`

Adds a descending sort criterion, preserving earlier criteria via stable sorting.
 Sorts stream descending, using `selector(value)` for the additional sort key.

---

#### `:pageCount(itemsPerPage)
`

Calculates the total number of pages required to display all items in the stream,
 given a number of items per page. This is a terminal operation.

---

#### `:pageSlice(itemsPerPage, pageNum)
`

Returns a new stream containing the elements for a specific page.
 Pages are 1-based.

---

#### `:reduce(reducer, initVal)`

Reduces stream elements to a single value using `reducer(accumulator, value)`. Note: will return `nil` if executed on an empty collection with no `initVal`.

---

#### `:renameFields(renameMap)
`

For each table element in the stream, creates a new table with specified fields renamed.
 Other fields are preserved.
 If an element is array-table or not a table - it is passed through unchanged.
 If an old field name in the renameMap does not exist in an element, it is ignored.
 Numeric-keyed fields could not be renamed.

---

#### `:selectFields(fieldsToSelect)
`

For each table element in the stream, creates a new table containing only the specified fields.
 If a specified field does not exist in an element, it's omitted in the new table.
 If an element is array-table or not a table - it is passed through unchanged.
 Numeric-keyed fields could not be selected.

---

#### `:singleOrDefault(defaultVal)
`

Returns the element if stream has one element, or `defaultVal` if zero or more than one elements.

---

#### `:singleOrError(msg)
`

Returns the element if stream has one element, or throws an error if zero or more than one elements.

---

#### `:singleOrNil()
`

Returns the element if stream has one element, or `nil` if zero or more than one elements.

---

#### `:skip(n)
`

Skips first `n` elements, returns new stream.

---

#### `:take(n)
`

Takes first `n` elements, returns new stream.

---

#### `:toMap(mapper)`

Transforms a sequence into a map-like table by applying a mapper function to each element. The mapper function should return a two-element table {key, value} or nil to skip. If the mapper returns something else or fewer/more elements, the entry is effectively skipped. If key or value is nil, the entry is skipped. In case of duplicate keys, the first occurrence takes precedence.

---

#### `:unique()
`

Returns new stream with unique elements, preserving first-occurrence order.
 Uniqueness by identity (reference for tables, value for primitives).

---

#### `:values()
`

Returns new stream of all values from `pairs()` iteration. Order not guaranteed for maps.

---

#### `.range(startNum, finishNum, stepNum)
`

Generates a stream of numbers in an arithmetic progression.

