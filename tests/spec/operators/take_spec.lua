local chain = require("chain")

describe("Chain:take()", function()

    it("should take the first n elements from a chain", function()
        chain({ 1, 2, 3, 4, 5 })
            :take(3)
            :values():assertEquals({ 1, 2, 3 })
    end)

    it("should return all elements when n is greater than chain size", function()
        chain({ 1, 2, 3 })
            :take(5)
            :values():assertEquals({ 1, 2, 3 })
    end)

    it("should return empty chain when n is 0", function()
        chain({ 1, 2, 3, 4, 5 })
            :take(0)
            :values():assertEquals({})
    end)

    it("should return empty chain when n is negative", function()
        chain({ 1, 2, 3, 4, 5 })
            :take(-3)
            :values():assertEquals({})
    end)

    it("should return empty chain when input chain is empty", function()
        chain({})
            :take(3)
            :values():assertEquals({})
    end)

    it("should preserve element order", function()
        chain({ "a", "b", "c", "d", "e" })
            :take(4)
            :values():assertEquals({ "a", "b", "c", "d" })
    end)

    it("should work with complex element types", function()
        local alice = { name = "Alice", age = 30 }
        local bob = { name = "Bob", age = 25 }
        local charlie = { name = "Charlie", age = 35 }
        chain({ alice, bob, charlie })
            :take(2)
            :values():assertEquals({ alice, bob })
    end)

    it("should throw an error when argument is not a number", function()
        expect(function()
            chain({}):take("not a number")
        end).to.fail("take(n): n must be an integer (got string: 'not a number')")
    end)

    it("should throw an error when argument is not an integer", function()
        expect(function()
            chain({}):take(2.7)
        end).to.fail("take(n): n must be an integer (got a non-integer number: 2.7)")
    end)

    it("should throw an error when argument is missing", function()
        expect(function()
            chain({}):take()
        end).to.fail("take(n): n must be an integer (got nil)")
    end)

    it("should return exactly one element when n is 1", function()
        chain({ 1, 2, 3, 4, 5 })
            :take(1)
            :values():assertEquals({ 1 })
    end)
end)
