local chain = require("chain")

describe("Chain:reduce()", function()

    it("should reduce elements to a single value using the reducer function", function()
        local data = {1, 2, 3, 4}
        local result = chain(data):reduce(function(acc, value)
            return acc + value
        end)
        expect(result).to.equal(10) -- 1 + 2 + 3 + 4 = 10
    end)

    it("should use the initial value if provided", function()
        local data = {1, 2, 3}
        local result = chain(data):reduce(function(acc, value)
            return acc + value
        end, 10)
        expect(result).to.equal(16) -- 10 + 1 + 2 + 3 = 16
    end)

    it("should return the first element if no initial value and only one element", function()
        local data = {42}
        local result = chain(data):reduce(function(acc, value)
            return acc + value
        end)
        expect(result).to.equal(42)
    end)

    it("should return nil for an empty chain with no initial value", function()
        local data = {}
        local result = chain(data):reduce(function(acc, value)
            return acc + value
        end)
        expect(result).to.equal(nil)
    end)

    it("should return the initial value for an empty chain", function()
        local data = {}
        local result = chain(data):reduce(function(acc, value)
            return acc + value
        end, 100)
        expect(result).to.equal(100)
    end)

    it("should work with non-numeric values", function()
        local data = {"a", "b", "c"}
        local result = chain(data):reduce(function(acc, value)
            return acc .. value
        end)
        expect(result).to.equal("abc")
    end)

    it("should allow complex accumulation operations", function()
        local data = {1, 2, 3, 4, 5}
        local result = chain(data):reduce(function(acc, value)
            acc.sum = acc.sum + value
            acc.count = acc.count + 1
            return acc
        end, {sum = 0, count = 0})

        expect(result.sum).to.equal(15)
        expect(result.count).to.equal(5)
    end)

    it("should process elements in the original sequence order", function()
        local data = {"a", "c", "b"}
        local processOrder = {}
        chain(data):reduce(function(acc, value)
            table.insert(processOrder, value)
            return acc .. value
        end, "")
        expect(processOrder).to.equal({"a", "c", "b"})
    end)

    it("should throw an error when reducer is not a function", function()
        expect(function()
            chain({}):reduce(-1)
        end).to.fail("reduce(reducer, initValue): reducer must be a function (got number: -1)")
    end)
end)
