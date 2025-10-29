local chain = require("chain")

describe("Chain:lastOrElse()", function()

    it("should return last element in a Dict chain", function()
        expect({
            chain({ a = 10, b = 20, c = 30 }):lastOrElse(40, "d", 4)
        }).to.equal(30, "c", 3)
    end)

    it("should return default value/key/index if chain is empty", function()
        expect({
            chain({}):lastOrElse(40, "d", 4)
        }).to.equal(40, "d", 4)
    end)

    it("should not throw assertion error when default index is not provided", function()
        expect({
            chain({}):lastOrElse( 40, "d")
        }).to.equal(40, "d")
    end)

    it("should throw assertion error when default index is not an integer", function()
        expect(function()
            chain({ a = 10, b = 20, c = 30 }):lastOrElse(40, "d", 2.7)
        end).to.fail("lastOrElse(dv, dk, di): di must be an integer or nil (got a non-integer number: 2.7)")
    end)
end)
