local chain = require("chain")

describe("Chain:order()", function()

    it("should sort numeric values in ascending order", function()
        local data = {5, 3, 8, 1, 2}
        local result = chain(data):order():toList()
        expect(result).to.equal({1, 2, 3, 5, 8})
    end)

    it("should sort string values alphabetically", function()
        local data = {"zebra", "apple", "banana", "cherry"}
        local result = chain(data):order():toList()
        expect(result).to.equal({"apple", "banana", "cherry", "zebra"})
    end)

    it("should handle empty chain", function()
        local data = {}
        local result = chain(data):order():toList()
        expect(result).to.equal({})
    end)

    it("should handle single element chain", function()
        local data = {42}
        local result = chain(data):order():toList()
        expect(result).to.equal({42})
    end)

    it("should sort negative and floating point numbers correctly", function()
        local data = {3.14, -5, 0, 2.71, -10}
        local result = chain(data):order():toList()
        expect(result).to.equal({-10, -5, 0, 2.71, 3.14})
    end)

    it("should handle duplicate values", function()
        local data = {3, 1, 4, 1, 5, 9, 2, 6, 5}
        local result = chain(data):order():toList()
        expect(result).to.equal({1, 1, 2, 3, 4, 5, 5, 6, 9})
    end)

    it("should create a new chain instance", function()
        local data = {3, 1, 2}
        local s1 = chain(data)
        local s2 = s1:order()

        -- s1 should remain unchanged
        expect(s1:toList()).to.equal({3, 1, 2})

        -- s2 should be sorted
        expect(s2:toList()).to.equal({1, 2, 3})
    end)

    it("should handle case sensitivity in string sorting", function()
        local data = {"apple", "Banana", "cherry", "Apple"}
        local result = chain(data):order():toList()

        -- In Lua's default ordering, uppercase comes before lowercase
        expect(result).to.equal({"Apple", "Banana", "apple", "cherry"})
    end)
end)
