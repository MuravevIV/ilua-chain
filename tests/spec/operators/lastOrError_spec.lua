local chain = require("chain")

describe("Chain:lastOrError()", function()

    it("should return the last element in a non-empty Dict chain", function()
        expect({
            chain({ a = 10, b = 20, c = 30 }):lastOrError()
        }).to.equal(30, "c", 3)
    end)

    it("should raise an error when chain is empty", function()
        expect(function()
            chain({}):lastOrError()
        end).to.fail("lastOrError(..) failed: chain is empty")
    end)
end)
