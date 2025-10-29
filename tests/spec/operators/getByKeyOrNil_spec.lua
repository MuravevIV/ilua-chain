local chain = require("chain")

describe("Chain:getByKeyOrNil()", function()

    it("should get value result by existing key", function()
        expect(
            chain({ a = 10, b = 20, c = 30 }):getByKeyOrNil("b")
        ).to.equal(20)
    end)

    it("should get nil result by non-existing key", function()
        expect(
            chain({ a = 10, b = 20, c = 30 }):getByKeyOrNil("d")
        ).to.equal(nil)
    end)

    it("should get value/key result by existing key", function()
        expect({
            chain({ a = 10, b = 20, c = 30 }):getByKeyOrNil("b")
        }).to.equal(20, "b", 2)
    end)

    it("should get nil/nil result by non-existing key", function()
        expect(
            chain({ a = 10, b = 20, c = 30 }):getByKeyOrNil("d")
        ).to.equal(nil, nil)
    end)

    it("should get value/key/index result by existing key", function()
        expect({
            chain({ a = 10, b = 20, c = 30 }):getByKeyOrNil("b")
        }).to.equal(20, "b", 2)
    end)

    it("should get nil/nil/nil result by non-existing key", function()
        expect(
            chain({ a = 10, b = 20, c = 30 }):getByKeyOrNil("d")
        ).to.equal(nil, nil, nil)
    end)
end)
