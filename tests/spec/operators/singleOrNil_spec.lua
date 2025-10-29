local chain = require("chain")

describe("Chain:singleOrNil()", function()

    it("should return the single element if the chain has exactly one element", function()
        local data = {42}
        local result = chain(data):singleOrNil()
        expect(result).to.equal(42)
    end)

    it("should return nil if the chain has zero elements", function()
        local data = {}
        local result = chain(data):singleOrNil()
        expect(result).to.equal(nil)
    end)

    it("should return nil if the chain has more than one element", function()
        local data = {1, 2}
        local result = chain(data):singleOrNil()
        expect(result).to.equal(nil)
    end)

    it("should handle multiple elements", function()
        local data = {10, 20, 30}
        local result = chain(data):singleOrNil()
        expect(result).to.equal(nil)
    end)
end)
