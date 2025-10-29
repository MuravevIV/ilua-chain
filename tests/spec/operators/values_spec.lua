local chain = require("chain")

describe("Chain:values()", function()

    it("should return all values from a table used as a map", function()
        chain({ a = 1, b = 2, c = 3 })
            :values()
            :assertEquals({ 1, 2, 3 })
    end)

    it("should return all elements from an array", function()
        chain({ "apple", "banana", "cherry" })
            :values()
            :assertEquals({ "apple", "banana", "cherry" })
    end)

    it("should return all values from mixed tables", function()
        chain({ 10, 20, a = "apple", b = "banana" })
            :values()
            :assertEquals({ 10, 20, "apple", "banana" })
    end)

    it("should return an empty chain for an empty table", function()
        chain({})
            :values()
            :assertEquals({})
    end)

    it("should work with tables containing nil values", function()
        chain({ a = 1, b = nil, c = 3 })
            :values()
            :assertEquals({ 1, 3 })
    end)

    it("should work with complex value types", function()
        local complexValue1 = { id = 1 }
        local complexValue2 = { id = 2 }
        chain({ key1 = complexValue1, key2 = complexValue2 })
            :values()
            :assertEquals({ complexValue1, complexValue2 })
    end)

    it("should handle numeric and string values of different types", function()
        local data = {
            a = 1,
            b = "hello",
            c = true,
            d = 3.14
        }
        chain(data)
            :values()
            :assertEquals({ 1, "hello", true, 3.14 })
    end)
end)
