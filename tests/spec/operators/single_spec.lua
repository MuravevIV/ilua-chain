local chain = require("chain")

describe("Chain:single()", function()

    it("should alias :single to :singleOrNil", function()
        expect(chain({}).single).to_not.equal(nil)
        expect(chain({}).single).to.equal(chain({}).singleOrNil)
    end)
end)
