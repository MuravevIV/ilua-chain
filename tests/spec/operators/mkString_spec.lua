
local chain = require("chain")

describe("Chain:mkString()", function()

    it("concatenates strings with default empty separator", function()
        local data = {"a", "b", "c"}

        local result = chain(data):mkString()

        expect(result).to.equal("abc")
    end)

    it("concatenates strings with custom separator", function()
        local data = {"a", "b", "c"}

        local result = chain(data):mkString(", ")

        expect(result).to.equal("a, b, c")
    end)

    it("concatenates numbers with custom separator", function()
        local data = {1, 2, 3}

        local result = chain(data):mkString("-")

        expect(result).to.equal("1-2-3")
    end)

    it("applies decorator to each element", function()
        local data = {1, 2, 3}

        local decorator = function(v)
            return tostring(v * 10)
        end

        local result = chain(data):mkString(", ", decorator)

        expect(result).to.equal("10, 20, 30")
    end)

    it("provides key and index to decorator for sequences", function()
        local data = {"a", "b", "c"}

        local decorator = function(v, k, i)
            return tostring(i) .. ":" .. v
        end

        local result = chain(data):mkString("; ", decorator)

        expect(result).to.equal("1:a; 2:b; 3:c")
    end)

    it("provides key and index to decorator for maps", function()
        local data = {x = "a", y = "b", z = "c"}

        local decorator = function(v, k, i)
            return k .. ":" .. v .. "(" .. tostring(i) .. ")"
        end

        local result = chain(data):mkString("; ", decorator)

        -- Order may vary, but check for presence
        local parts = {}
        for part in result:gmatch("[^; ]+") do
            table.insert(parts, part)
        end
        table.sort(parts)
        expect(table.concat(parts, "; ")).to.equal("x:a(1); y:b(2); z:c(3)")
    end)

    it("returns empty string for empty chain", function()
        local data = {}

        local result = chain(data):mkString(", ")

        expect(result).to.equal("")
    end)

    it("handles single element without separator", function()
        local data = {"hello"}

        local result = chain(data):mkString(", ")

        expect(result).to.equal("hello")
    end)

    it("applies decorator to single element", function()
        local data = {5}

        local decorator = function(v)
            return tostring(v + 1)
        end

        local result = chain(data):mkString(", ", decorator)

        expect(result).to.equal("6")
    end)

    it("fails when concatenating non-string non-number without decorator", function()
        local data = {{}, {}}

        expect(function()
            chain(data):mkString()
        end).to.fail("attempt to concatenate a table value (local 'v')")
    end)

    it("handles nil separator as empty string", function()
        local data = {"a", "b"}

        local result = chain(data):mkString(nil)

        expect(result).to.equal("ab")
    end)
end)
