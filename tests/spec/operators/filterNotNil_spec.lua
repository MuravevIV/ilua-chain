
local chain = require("chain")

describe("Chain:filterNotNil()", function()

    it("removes nil values from a sequence", function()
        local data = {1, nil, "two", nil, 3}

        local result = chain(data):filterNotNil():toList()

        expect(result).to.equal({1, "two", 3})
    end)

    it("preserves non-nil values in a map", function()
        local data = {
            a = 1,
            b = nil,
            c = "three",
            d = nil
        }

        local result = chain(data):filterNotNil():toMap()

        expect(result.a).to.equal(1)
        expect(result.c).to.equal("three")
        expect(result.b).to.equal(nil)
        expect(result.d).to.equal(nil)

        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(2)
    end)

    it("returns empty for all nil values", function()
        local data = {nil, nil, nil}

        local result = chain(data):filterNotNil():toList()

        expect(result).to.equal({})
    end)

    it("returns unchanged for no nil values", function()
        local data = {1, 2, 3}

        local result = chain(data):filterNotNil():toList()

        expect(result).to.equal({1, 2, 3})
    end)

    it("returns empty for empty input", function()
        local data = {}

        local result = chain(data):filterNotNil():toList()

        expect(result).to.equal({})
    end)

    it("does not modify the original collection", function()
        local data = {1, nil, 2}

        chain(data):filterNotNil():toList()

        expect(#data).to.equal(3)
        expect(data[2]).to.equal(nil)
    end)
end)
