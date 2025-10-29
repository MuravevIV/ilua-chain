local chain = require("chain")

describe("Chain:at()", function()

    it("should alias :at to :getAtPositionOrNil", function()
        expect(chain({}).at).to_not.equal(nil)
        expect(chain({}).at).to.equal(chain({}).getAtPositionOrNil)
    end)
end)
