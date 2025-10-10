local Chain = require("chain_class")

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
