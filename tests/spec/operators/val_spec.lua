local chain = require("chain")

describe("Chain:val()", function()

    it("should alias :val to :getByValueOrNil", function()
        expect(chain({}).val).to_not.equal(nil)
        expect(chain({}).val).to.equal(chain({}).getByValueOrNil)
    end)
end)
