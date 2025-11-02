
local chain = require("chain")

describe("Chain:remove()", function()

    it("removes all occurrences from sequence", function()
        local data = {1, 2, 1, 3, 1}

        local result = chain(data):remove(1):toList()

        expect(result).to.equal({2, 3})
    end)

    it("removes from map preserving keys", function()
        local data = {a = "apple", b = "banana", c = "apple"}

        local result = chain(data):remove("apple"):toMap()

        expect(result.a).to.equal(nil)
        expect(result.b).to.equal("banana")
        expect(result.c).to.equal(nil)
    end)

    it("returns unchanged if no matches", function()
        local data = {1, 2, 3}

        local result = chain(data):remove(4):toList()

        expect(result).to.equal({1, 2, 3})
    end)

    it("handles empty chain", function()
        local data = {}

        local result = chain(data):remove("anything"):toList()

        expect(result).to.equal({})
    end)

    it("removes nil values", function()
        local data = {1, nil, 2, nil}

        local result = chain(data):remove(nil):toList()

        expect(result).to.equal({1, 2})
    end)

    it("removes complex objects if identical", function()
        local obj = {x = 1}
        local data = {obj, {x = 1}, obj}

        local result = chain(data):remove(obj):toList()

        expect(result).to.equal({{x = 1}})
    end)

    it("does not modify original chain", function()
        local data = {1, 2, 1}

        local original = chain(data)
        original:remove(1)

        expect(original:toList()).to.equal({1, 2, 1})
    end)

    it("preserves non-integer keys", function()
        local data = {[1.5] = "float", a = "string", [2] = "int"}

        local result = chain(data):remove("string"):toMap()

        expect(result[1.5]).to.equal("float")
        expect(result.a).to.equal(nil)
        expect(result[2]).to.equal("int")
    end)
end)
