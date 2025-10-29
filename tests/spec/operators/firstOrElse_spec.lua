local chain = require("chain")

describe("Chain:firstOrElse()", function()

    it("should return first element in a Dict chain", function()
        expect({
            chain({ a = 10, b = 20, c = 30 }):firstOrElse(40, "d", 4)
        }).to.equal(10, "a", 1)
    end)

    it("should return default value/key/index if chain is empty", function()
        expect({
            chain({}):firstOrElse(40, "d", 4)
        }).to.equal(40, "d", 4)
    end)

    it("should not throw assertion error when default index is not provided", function()
        expect({
            chain({}):firstOrElse( 40, "d")
        }).to.equal(40, "d")
    end)

    it("should throw assertion error when default index is not an integer", function()
        expect(function()
            chain({ a = 10, b = 20, c = 30 }):firstOrElse(40, "d", 2.7)
        end).to.fail("firstOrElse(dv, dk, di): di must be an integer or nil (got a non-integer number: 2.7)")
    end)
end)
