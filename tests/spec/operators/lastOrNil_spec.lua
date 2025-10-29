local chain = require("chain")

describe("chain:lastOrNil()", function()

    it("should return the last element in a non-empty List chain", function()
        expect({
            chain({ 10, 20, 30 }):lastOrNil()
        }).to.equal(30, 3, 3)
    end)

    it("should return the last element in a non-empty Dict chain", function()
        expect({
            chain({ a = 10, b = 20, c = 30 }):lastOrNil()
        }).to.equal(30, "c", 3)
    end)

    it("should return nil for an empty chain", function()
        expect(
            chain({}):lastOrNil()
        ).to.equal(nil, nil, nil)
    end)

    it("should return the single element for a one-element chain", function()
        expect({
            chain({ a = 10 }):lastOrNil()
        }).to.equal(10, "a", 1)
    end)

    it("should return false value correctly", function()
        expect({
            chain({ false }):lastOrNil()
        }).to.equal(false, 1, 1)
    end)
end)
