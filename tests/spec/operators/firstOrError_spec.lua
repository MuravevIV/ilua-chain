local chain = require("chain")

describe("Chain:firstOrError()", function()

    it("should return the first element in a non-empty Dict chain", function()
        expect({
            chain({ a = 10, b = 20, c = 30 }):firstOrError()
        }).to.equal(10, "a", 1)
    end)

    it("should raise an error when chain is empty", function()
        expect(function()
            chain({}):firstOrError()
        end).to.fail("firstOrError(..) failed: chain is empty")
    end)

    it("should raise a custom error when chain is empty and custom error message is provided", function()
        expect(function()
            chain({}):firstOrError("Expected at least one element to be present")
        end).to.fail("Expected at least one element to be present")
    end)
end)
