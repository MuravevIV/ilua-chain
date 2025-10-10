local chain = require("chain")

describe("Chain:isEmpty()", function()

    it("should return false for a non-empty chain", function()
        expect(
            chain({1, 2, 3}):isEmpty()
        ).to.equal(false)
    end)

    it("should return true for an empty chain", function()
        expect(
            chain({}):isEmpty()
        ).to.equal(true)
    end)

    it("should handle a single element", function()
        expect(
            chain({42}):isEmpty()
        ).to.equal(false)
    end)
end)
