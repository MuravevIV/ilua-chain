local chain = require("chain")

describe("Chain:findFirstOrNil()", function()

    it("should return the first matching element in a chain", function()
        expect(
            chain({1, 2, 3, 4, 5})
                :findFirstOrNil(function(v) return v > 3 end)
        ).to.equal(4)
    end)

    it("should work with Dict elements based on a predicate function", function()
        expect(
            chain({a = 10, b = 20, c = 30})
                :findFirstOrNil(function(v) return v > 15 end)
        ).to.equal(20)
    end)

    it("should pass key to the predicate function", function()
        expect(
            chain({a = 10, b = 20, c = 30, d = 40, e = 50})
                :findFirstOrNil(function(v, k) return k == "c" end)
        ).to.equal(30)
    end)

    it("should pass index to the predicate function", function()
        expect(
            chain({a = 10, b = 20, c = 30, d = 40, e = 50})
                :findFirstOrNil(function(v, k, i) return i == 4 end)
        ).to.equal(40)
    end)

    it("should return trio for multiple assignment result", function()
        expect({
            chain({a = 10, b = 20, c = 30})
                :findFirstOrNil(function(v) return v > 15 end)
        }).to.equal(20, "b", 2)
    end)

    it("should return nil if no element matches the predicate", function()
        expect(
            chain({10, 20, 30})
                :findFirstOrNil(function(v) return v > 100 end)
        ).to.equal(nil)
    end)

    it("should return nil for an empty chain", function()
        expect(
            chain({})
                :findFirstOrNil(function() return true end)
        ).to.equal(nil)
    end)

    it("should return the single element if it matches in a one-element chain", function()
        expect(
            chain({42})
                :findFirstOrNil(function(v) return v == 42 end)
        ).to.equal(42)
    end)

    it("should return nil if a single element does not match the predicate", function()
        expect(
            chain({42})
                :findFirstOrNil(function(v) return v == 100 end)
        ).to.equal(nil)
    end)

    it("should return false value correctly", function()
        expect(
            chain({false})
                :findFirstOrNil(function(v) return not v end)
        ).to.equal(false)
    end)

    it("should raise an error if the predicate is not a function", function()
        expect(function()
            chain({1, 2, 3}):findFirstOrNil("not a function")
        end).to.fail("findFirstOrNil(pred): pred must be a function (got string: 'not a function')")
    end)

    it("should raise an error if the predicate is not defined", function()
        expect(function()
            chain({1, 2, 3}):findFirstOrNil()
        end).to.fail("findFirstOrNil(pred): pred must be a function (got nil)")
    end)
end)
