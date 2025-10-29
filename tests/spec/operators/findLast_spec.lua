local chain = require("chain")

describe("Chain:findLast()", function()

    it("should alias :findLast to :singleOrNil", function()
        expect(chain({}).findLast).to_not.equal(nil)
        expect(chain({}).findLast).to.equal(chain({}).findLastOrNil)
    end)
end)
