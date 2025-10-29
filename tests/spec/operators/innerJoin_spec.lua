
local chain = require("chain")

describe("Chain:innerJoin()", function()

    it("performs inner join with single matches", function()
        local left = {
            {id = 1, name = "Alice"},
            {id = 2, name = "Bob"},
            {id = 3, name = "Charlie"}
        }
        local right = {
            {id = 1, score = 90},
            {id = 2, score = 85},
            {id = 4, score = 70}
        }

        local lKeyFn = function(el, k, i) return el.id end
        local rKeyFn = function(el, k, i) return el.id end
        local resFn = function(l, r) return {name = l.name, score = r.score} end

        local result = chain(left):innerJoin(chain(right), lKeyFn, rKeyFn, resFn):toList()

        expect(result).to.equal({
            {name = "Alice", score = 90},
            {name = "Bob", score = 85}
        })
    end)

    it("performs inner join with multiple matches on one key", function()
        local left = {
            {id = 1, name = "Alice"},
            {id = 2, name = "Bob"}
        }
        local right = {
            {id = 1, score = 90},
            {id = 1, score = 85},
            {id = 2, score = 70}
        }

        local lKeyFn = function(el, k, i) return el.id end
        local rKeyFn = function(el, k, i) return el.id end
        local resFn = function(l, r) return {name = l.name, score = r.score} end

        local result = chain(left):innerJoin(chain(right), lKeyFn, rKeyFn, resFn):toList()

        expect(result).to.equal({
            {name = "Alice", score = 90},
            {name = "Alice", score = 85},
            {name = "Bob", score = 70}
        })
    end)

    it("returns empty when no matches", function()
        local left = {
            {id = 1, name = "Alice"}
        }
        local right = {
            {id = 2, score = 85}
        }

        local lKeyFn = function(el, k, i) return el.id end
        local rKeyFn = function(el, k, i) return el.id end
        local resFn = function(l, r) return {name = l.name, score = r.score} end

        local result = chain(left):innerJoin(chain(right), lKeyFn, rKeyFn, resFn):toList()

        expect(result).to.equal({})
    end)

    it("handles empty left chain", function()
        local left = {}
        local right = {
            {id = 1, score = 90}
        }

        local lKeyFn = function(el, k, i) return el.id end
        local rKeyFn = function(el, k, i) return el.id end
        local resFn = function(l, r) return {score = r.score} end

        local result = chain(left):innerJoin(chain(right), lKeyFn, rKeyFn, resFn):toList()

        expect(result).to.equal({})
    end)

    it("handles empty right chain", function()
        local left = {
            {id = 1, name = "Alice"}
        }
        local right = {}

        local lKeyFn = function(el, k, i) return el.id end
        local rKeyFn = function(el, k, i) return el.id end
        local resFn = function(l, r) return {name = l.name} end

        local result = chain(left):innerJoin(chain(right), lKeyFn, rKeyFn, resFn):toList()

        expect(result).to.equal({})
    end)

    it("uses index in key extractors", function()
        local left = {"a", "b", "c"}
        local right = {"x", "y", "z"}

        local lKeyFn = function(el, k, i) return i % 2 end
        local rKeyFn = function(el, k, i) return i % 2 end
        local resFn = function(l, r) return l .. r end

        local result = chain(left):innerJoin(chain(right), lKeyFn, rKeyFn, resFn):toList()

        expect(result).to.equal({"ax", "az", "by", "cx", "cz"})
    end)

    it("uses key in key extractors", function()
        local left = {foo = "a", bar = "b", caz = "c"}
        local right = {bux = "x", buy = "y", czz = "z"}

        local lKeyFn = function(el, k, i) return string.sub(k, 1, 1) end
        local rKeyFn = function(el, k, i) return string.sub(k, 1, 1) end
        local resFn = function(l, r) return l .. r end

        local result = chain(left):innerJoin(chain(right), lKeyFn, rKeyFn, resFn):toList()

        local parts = {}
        for _, v in ipairs(result) do
            table.insert(parts, v)
        end
        table.sort(parts)
        expect(parts).to.equal({"bx", "by", "cz"})
    end)

    it("throws error if rChain is not a Chain instance", function()
        local left = {1}
        local notChain = {}

        local lKeyFn = function(el, k, i) return el end
        local rKeyFn = function(el, k, i) return el end
        local resFn = function(l, r) return l + r end

        expect(function()
            chain(left):innerJoin(notChain, lKeyFn, rKeyFn, resFn)
        end).to.fail("rChain must be a Chain instance")
    end)

    it("throws error if lKeyExtFn is not a function", function()
        local left = {1}
        local right = chain({2})

        local lKeyFn = "not function"
        local rKeyFn = function(el, k, i) return el end
        local resFn = function(l, r) return l + r end

        expect(function()
            chain(left):innerJoin(right, lKeyFn, rKeyFn, resFn)
        end).to.fail("innerJoin(rChain, lKeyExtFn, rKeyExtFn, resSelFn): lKeyExtFn must be a function (got string: 'not function')")
    end)

    it("throws error if rKeyExtFn is not a function", function()
        local left = {1}
        local right = chain({2})

        local lKeyFn = function(el, k, i) return el end
        local rKeyFn = "not function"
        local resFn = function(l, r) return l + r end

        expect(function()
            chain(left):innerJoin(right, lKeyFn, rKeyFn, resFn)
        end).to.fail("innerJoin(rChain, lKeyExtFn, rKeyExtFn, resSelFn): rKeyExtFn must be a function (got string: 'not function')")
    end)

    it("throws error if resSelFn is not a function", function()
        local left = {1}
        local right = chain({2})

        local lKeyFn = function(el, k, i) return el end
        local rKeyFn = function(el, k, i) return el end
        local resFn = "not function"

        expect(function()
            chain(left):innerJoin(right, lKeyFn, rKeyFn, resFn)
        end).to.fail("innerJoin(rChain, lKeyExtFn, rKeyExtFn, resSelFn): resSelFn must be a function (got string: 'not function')")
    end)
end)
