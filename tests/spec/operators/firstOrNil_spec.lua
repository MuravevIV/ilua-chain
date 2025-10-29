local chain = require("chain")

describe("chain:firstOrNil()", function()

    it("should return the first element in a non-empty List chain", function()
        expect({
            chain({ 10, 20, 30 }):firstOrNil()
        }).to.equal(10, 1, 1)
    end)

    it("should return the first element in a non-empty Dict chain", function()
        expect({
            chain({ a = 10, b = 20, c = 30 }):firstOrNil()
        }).to.equal(10, "a", 1)
    end)

    it("should return nil for an empty chain", function()
        expect(
            chain({}):firstOrNil()
        ).to.equal(nil, nil, nil)
    end)

    it("should return the single element for a one-element chain", function()
        expect({
            chain({ a = 10 }):firstOrNil()
        }).to.equal(10, "a", 1)
    end)

    it("should return false value correctly", function()
        expect({
            chain({ false }):firstOrNil()
        }).to.equal(false, 1, 1)
    end)
end)
