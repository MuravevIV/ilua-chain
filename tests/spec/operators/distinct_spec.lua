local chain = require("chain")

describe("Chain:distinct()", function()

    it("should filter out duplicate primitive values", function()
        chain({1, 2, 2, 3, 1, 4, 3, 5})
            :distinct()
            :assertEquals({1, 2, 3, 4, 5})
    end)

    it("should preserve first-occurrence order", function()
        chain({3, 1, 4, 1, 5, 9, 2, 6, 5})
            :distinct()
            :assertEquals({3, 1, 4, 5, 9, 2, 6})
    end)

    it("should return an empty chain for an empty input", function()
        chain({})
            :distinct()
            :assertEquals({})
    end)

    it("should handle string values", function()
        chain({"a", "b", "a", "c", "b", "d"})
            :distinct()
            :assertEquals({"a", "b", "c", "d"})
    end)

    it("should handle keyed values", function()
        chain({a = 10, b = 20, c = 10, d = 30, e = 20, f = 40})
            :distinct()
            :assertEquals({a = 10, b = 20, d = 30, f = 40})
    end)

    it("should use reference equality for tables", function()
        local t1 = {x = 1}
        local t2 = {x = 1}  -- Same content, different reference
        local t3 = t1       -- Same reference as t1
        chain({t1, t2, t3, {x = 1}})
            :distinct()
            :assertEquals({t1, t2, {x = 1}})
    end)

    it("should handle mixed types", function()
        chain({1, "1", true, 1, "1", true, false})
            :distinct()
            :assertEquals({1, "1", true, false})
    end)

    it("should work with a chain of all duplicate elements", function()
        chain({5, 5, 5, 5, 5})
            :distinct()
            :assertEquals({5})
    end)
end)
