
local chain = require("chain")

describe("Chain:append()", function()

    it("appends to a sequence without explicit key", function()
        local data = {10, 20, 30}

        local result = chain(data):append(40):toList()

        expect(result).to.equal({10, 20, 30, 40})
    end)

    it("appends to an empty chain without explicit key", function()
        local data = {}

        local result = chain(data):append("new"):toList()

        expect(result).to.equal({"new"})
    end)

    it("appends to a map without integer keys without explicit key", function()
        local data = {a = "apple", b = "banana"}

        local result = chain(data):append("cherry"):toMap()

        expect(result.a).to.equal("apple")
        expect(result.b).to.equal("banana")
        expect(result[1]).to.equal("cherry")
    end)

    it("appends to a mixed table without explicit key", function()
        local data = {10, 20, c = "cat"}

        local result = chain(data):append(30):toMap()

        expect(result[1]).to.equal(10)
        expect(result[2]).to.equal(20)
        expect(result[3]).to.equal(30)
        expect(result.c).to.equal("cat")
    end)

    it("preserves gaps in sequences without explicit key", function()
        local data = {[1] = "one", [3] = "three"}

        local result = chain(data):append("four"):toMap()

        expect(result[1]).to.equal("one")
        expect(result[3]).to.equal("three")
        expect(result[4]).to.equal("four")
    end)

    it("appends non-table element without explicit key", function()
        local data = {1, 2}

        local result = chain(data):append("three"):toList()

        expect(result).to.equal({1, 2, "three"})
    end)

    it("does not modify original chain", function()
        local data = {1, 2}

        local original = chain(data)
        original:append(3)

        expect(original:toList()).to.equal({1, 2})
    end)

    it("appends to chain with non-integer numeric keys without explicit key", function()
        local data = {[1.5] = "one point five"}

        local result = chain(data):append("two"):toMap()

        expect(result[1.5]).to.equal("one point five")
        expect(result[1]).to.equal("two")
    end)

    it("appends with explicit numeric key", function()
        local data = {10, 20}

        local result = chain(data):append(30, 5):toMap()

        expect(result[1]).to.equal(10)
        expect(result[2]).to.equal(20)
        expect(result[5]).to.equal(30)
    end)

    it("appends with explicit string key", function()
        local data = {a = "apple"}

        local result = chain(data):append("banana", "b"):toMap()

        expect(result.a).to.equal("apple")
        expect(result.b).to.equal("banana")
    end)

    it("overwrites if explicit key exists", function()
        local data = {1, 2, 3}

        local result = chain(data):append("overwritten", 2):toList()

        expect(result).to.equal({1, "overwritten", 3})
    end)

    it("appends with explicit key to empty chain", function()
        local data = {}

        local result = chain(data):append("value", "key"):toMap()

        expect(result.key).to.equal("value")
    end)

    it("appends nil with explicit key", function()
        local data = {1}

        local result = chain(data):append(nil, "nilkey"):toMap()

        expect(result[1]).to.equal(1)
        expect(result.nilkey).to.equal(nil)
    end)
end)
