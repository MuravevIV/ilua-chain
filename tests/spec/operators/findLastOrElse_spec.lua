local chain = require("chain")

describe("Chain:findLastOrElse()", function()

    it("should return the last matching element in a chain", function()
        expect({
            chain({ a = 10, b = 20, c = 30 })
                :findLastOrElse(function(v) return v < 25 end)
        }).to.equal(20, "b", 2)
    end)

    it("should return default value/key/index if no element matches the predicate", function()
        expect({
            chain({ a = 10, b = 20, c = 30 })
                :findLastOrElse(function(v) return v > 100 end, 40, "d", 4)
        }).to.equal(40, "d", 4)
    end)

    it("should not throw assertion error when default index is not provided", function()
        expect({
            chain({ a = 10, b = 20, c = 30 })
                :findLastOrElse(function(v) return v > 100 end, 40, "d")
        }).to.equal(40, "d")
    end)

    it("should throw assertion error when default index is not an integer", function()
        expect(function()
            chain({ a = 10, b = 20, c = 30 })
                :findLastOrElse(function(v) return v > 100 end, 40, "d", 2.7)
        end).to.fail("findLastOrElse(pred, dv, dk, di): di must be an integer or nil (got a non-integer number: 2.7)")
    end)
end)
