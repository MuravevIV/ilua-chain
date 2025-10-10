local chain = require("chain")

describe("Chain:singleOrDefault()", function()

    it("should return the single element if the chain has exactly one element", function()
        local data = {42}
        local result = chain(data):singleOrElse(-1)
        expect(result).to.equal(42)
    end)

    it("should return the default value if the chain has zero elements", function()
        local data = {}
        local result = chain(data):singleOrElse("no elements")
        expect(result).to.equal("no elements")
    end)

    it("should return the default value if the chain has more than one element", function()
        local data = {1, 2}
        local result = chain(data):singleOrElse("too many")
        expect(result).to.equal("too many")
    end)

    it("should handle nil as defaultVal", function()
        local data = {}
        local result = chain(data):singleOrElse(nil)
        expect(result).to.equal(nil)
    end)
end)
