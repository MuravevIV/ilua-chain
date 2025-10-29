local chain = require("chain")

describe("Chain:findFirstOrError()", function()

    it("should return the first matching element in a chain", function()
        expect({
            chain({ a = 10, b = 20, c = 30 })
                :findFirstOrError(function(v, k, i) return v > 15 and k ~= "a" and i > 1 end)
        }).to.equal(20, "b", 2)
    end)

    it("should raise an error when no element matches", function()
        expect(function()
            chain({ a = 10, b = 20, c = 30 })
                :findFirstOrError(function(v, k, i) return v > 15 and k ~= "b" and i < 3 end)
        end).to.fail("findFirstOrError(..) failed: no element found by predicate")
    end)
end)
