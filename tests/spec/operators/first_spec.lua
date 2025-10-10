local chain = require("chain")

describe("Chain:first()", function()

    it("should alias :first to :firstOrNil", function()
        expect(chain({}).first).to_not.equal(nil)
        expect(chain({}).first).to.equal(chain({}).firstOrNil)
    end)
end)
