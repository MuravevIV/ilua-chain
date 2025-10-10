local chain = require("chain")

describe("Chain:get()", function()

    it("should alias :get to :getByKeyOrNil", function()
        expect(chain({}).get).to_not.equal(nil)
        expect(chain({}).get).to.equal(chain({}).getByKeyOrNil)
    end)
end)
