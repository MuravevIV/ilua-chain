local chain = require("chain")

describe("Chain:skip()", function()

    it("should skip the first n elements from a chain", function()
        chain({ 1, 2, 3, 4, 5 })
            :skip(3)
            :values():assertEquals({ 4, 5 })
    end)

    it("should return empty chain when n is greater than chain size", function()
        chain({ 1, 2, 3 })
            :skip(5)
            :values():assertEquals({})
    end)

    it("should return all elements when n is 0", function()
        chain({ 1, 2, 3, 4, 5 })
            :skip(0)
            :values():assertEquals({ 1, 2, 3, 4, 5 })
    end)

    it("should return all elements when n is negative", function()
        chain({ 1, 2, 3, 4, 5 })
            :skip(-3)
            :values():assertEquals({ 1, 2, 3, 4, 5 })
    end)

    it("should return empty chain when input chain is empty", function()
        chain({})
            :skip(3)
            :values():assertEquals({})
    end)

    it("should preserve element order", function()
        chain({ "a", "b", "c", "d", "e" })
            :skip(2)
            :values():assertEquals({ "c", "d", "e" })
    end)

    it("should work with complex element types", function()
        local alice = { name = "Alice", age = 30 }
        local bob = { name = "Bob", age = 25 }
        local charlie = { name = "Charlie", age = 35 }
        chain({ alice, bob, charlie })
            :skip(1)
            :values():assertEquals({ bob, charlie })
    end)

    it("should throw an error when argument is not a number", function()
        expect(function()
            chain({}):skip("not a number")
        end).to.fail("skip(n): n must be an integer (got string: 'not a number')")
    end)

    it("should throw error when argument is not an integer", function()
        expect(function()
            chain({}):skip(2.7)
        end).to.fail("skip(n): n must be an integer (got a non-integer number: 2.7)")
    end)

    it("should throw an error when argument is missing", function()
        expect(function()
            chain({}):skip()
        end).to.fail("skip(n): n must be an integer (got nil)")
    end)

    it("should skip all elements when n equals collection size", function()
        chain({ 1, 2, 3, 4, 5 })
            :skip(5)
            :values():assertEquals({})
    end)
end)
