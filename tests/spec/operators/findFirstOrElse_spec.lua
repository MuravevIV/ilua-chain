local chain = require("chain")

describe("Chain:findFirstOrElse()", function()

    it("should return the first matching element in a chain", function()
        expect({
            chain({ a = 10, b = 20, c = 30 })
                :findFirstOrElse(function(v) return v > 15 end, 20)
        }).to.equal(20, "b", 2)
    end)

    it("should return default value if no element matches the predicate - but no key nor index", function()
        expect(
            chain({ 10, 20, 30 })
                :findFirstOrElse(function(v) return v > 100 end, 100)
        ).to.equal(100, nil, nil)
    end)
end)
