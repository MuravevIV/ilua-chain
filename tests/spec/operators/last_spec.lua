local chain = require("chain")

describe("Chain:last()", function()

    it("should alias :last to :lastOrNil", function()
        expect(chain({}).last).to_not.equal(nil)
        expect(chain({}).last).to.equal(chain({}).lastOrNil)
    end)
end)
