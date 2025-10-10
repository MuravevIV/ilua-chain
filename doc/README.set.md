
```lua
local chain = require("chain")

local data = {1, 2, 2, 3, 3}
local ch = chain(data)
print(ch) -- > {1, 2, 2, 3, 3}
ch = ch:append(3)
print(ch) -- > {1, 2, 2, 3, 3, 3}
ch = ch:asSet()
print(ch) -- > {1, 2, 3}
ch = ch:append(3)
print(ch) -- > {1, 2, 3}
ch = ch:asNonSet()
print(ch) -- > {1, 2, 3}
ch = ch:append(3)
print(ch) -- > {1, 2, 3, 3}
```
