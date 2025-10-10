local util = require("src.util")

describe("util.isArray", function()

    it("should return true for an empty table", function()
        local t = {}
        expect(util.isArray(t)).to.equal(true)
    end)

    it("should return true for consecutive numeric indices from 1..#t", function()
        local t = { "a", "b", "c" }
        expect(util.isArray(t)).to.equal(true)
    end)

    it("should return false for tables with a gap/hole", function()
        local t = { "a", nil, "c" } -- #t equals 1 if we rely on contiguous counting
        expect(util.isArray(t)).to.equal(false)
    end)

    it("should return false for tables with non-sequential numeric indices", function()
        local t = {}
        t[2] = "second" -- #t = 0 if index 1 is missing
        expect(util.isArray(t)).to.equal(false)
    end)

    it("should return false for dictionary-like tables", function()
        local t = { key1 = "value1", key2 = "value2" }
        expect(util.isArray(t)).to.equal(false)
    end)

    it("should return false for tables with non-numeric keys even if #t > 0", function()
        local t = { "a", "b" }
        t["extra"] = "extra"
        expect(util.isArray(t)).to.equal(false)
    end)

    it("should handle mixed tables (some numeric, some string keys) by returning false", function()
        local t = { "a", "b", foo = "bar" }
        expect(util.isArray(t)).to.equal(false)
    end)

    it("should return true for numeric arrays even if values are repeated or not distinct", function()
        local t = { 42, 42, 42 }
        expect(util.isArray(t)).to.equal(true)
    end)
end)

describe("util.shallowCopy", function()

    it("returns non-table values as-is", function()
        local numInput = 42
        local numOutput = util.shallowCopy(numInput)
        expect(numOutput).to.equal(numInput)

        local strInput = "hello"
        local strOutput = util.shallowCopy(strInput)
        expect(strOutput).to.equal(strInput)

        local boolInput = true
        local boolOutput = util.shallowCopy(boolInput)
        expect(boolOutput).to.equal(boolInput)

        local nilInput = nil
        local nilOutput = util.shallowCopy(nilInput)
        expect(nilOutput).to.equal(nil)
    end)

    it("creates a distinct table for table inputs", function()
        local original = { x = 1, y = 2 }
        local copy = util.shallowCopy(original)

        -- They should not be the same table
        expect(copy).to_not.be(original)

        -- But they should be equal by-fields
        expect(copy).to.equal(original)
    end)

    it("shallow-copies only one level", function()
        local original = {
            nested = {
                key = "value"
            }
        }
        local copy = util.shallowCopy(original)

        -- The new table and the original table should be different
        expect(copy).to_not.be(original)

        -- But they should be equal by-fields
        expect(copy).to.equal(original)
    end)

    it("copies all top-level keys", function()
        local original = {
            a = "apple",
            b = "banana",
            c = "cherry"
        }
        local copy = util.shallowCopy(original)
        expect(copy.a).to.equal(original.a)
        expect(copy.b).to.equal(original.b)
        expect(copy.c).to.equal(original.c)
    end)
end)
