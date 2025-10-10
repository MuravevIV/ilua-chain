local chain = require("chain")

describe("Chain:find()", function()

    it("should alias :find to :findFirstOrNil", function()
        expect(chain({}).find).to_not.equal(nil)
        expect(chain({}).find).to.equal(chain({}).findFirstOrNil)
    end)
end)
