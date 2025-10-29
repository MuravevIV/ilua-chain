local chain = require("chain")

describe("Chain:count()", function()

    it("should return the number of elements in a non-empty chain", function()
        local result = chain({1, 2, 3, 4, 5}):count()
        expect(result).to.equal(5)
    end)

    it("should return zero for an empty chain", function()
        local result = chain({}):count()
        expect(result).to.equal(0)
    end)

    it("should return correct count for a single element chain", function()
        local result = chain({42}):count()
        expect(result).to.equal(1)
    end)

    it("should work with chains of different element types", function()
        local result = chain({"a", 2, true, {}, function() end}):count()
        expect(result).to.equal(5)
    end)

    it("should count all elements of sparse arrays", function()
        local result = chain({[1] = "a", [3] = "c"}):count()
        expect(result).to.equal(2)
    end)

    it("should count all elements of the table", function()
        local result = chain({1, 2, 3, foo = "bar", baz = "qux"}):count()
        expect(result).to.equal(5)
    end)

    it("should handle large arrays", function()
        local data = {}
        for i = 1, 1000 do
            data[i] = i
        end
        local result = chain(data):count()
        expect(result).to.equal(1000)
    end)
end)
