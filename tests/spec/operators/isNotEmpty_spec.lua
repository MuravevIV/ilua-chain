local chain = require("chain")

describe("Chain:isNotEmpty()", function()

    it("should return true for a non-empty chain", function()
        expect(
            chain({1, 2, 3}):isNotEmpty()
        ).to.equal(true)
    end)

    it("should return false for an empty chain", function()
        expect(
            chain({}):isNotEmpty()
        ).to.equal(false)
    end)

    it("should handle a single element", function()
        expect(
            chain({42}):isNotEmpty()
        ).to.equal(true)
    end)
end)
