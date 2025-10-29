local chain = require("chain")

describe("Chain:all()", function()

    it("should return true if all elements match the predicate", function()
        expect(
            chain({2, 4, 6, 8}):all(function(v) return v % 2 == 0 end)
        ).to.equal(true)
    end)

    it("should return false if any element fails the predicate", function()
        expect(
            chain({2, 4, 5, 8}):all(function(v) return v % 2 == 0 end)
        ).to.equal(false)
    end)

    it("should provide correct key to predicate function", function()
        expect(
            chain({a = 10, b = 20, c = 30}):all(function(_, k)
                return k == "a" or k == "b" or k == "c"
            end)
        ).to.equal(true)
    end)

    it("should provide correct index to predicate function", function()
        expect(
            chain({a = 10, b = 20, c = 30}):all(function(_, _, i)
                return 1 <= i and i <= 3
            end)
        ).to.equal(true)
    end)

    it("should return true for empty chain", function()
        expect(
            chain({}):all(function(v) return v > 0 end)
        ).to.equal(true)
    end)

    it("should handle single element chain", function()
        expect(
            chain({42}):all(function(v) return v > 0 end)
        ).to.equal(true)
        expect(
            chain({42}):all(function(v) return v < 0 end)
        ).to.equal(false)
    end)

    it("should work with complex element types", function()
        local data = {
            {name = "Alice", age = 25},
            {name = "Bob", age = 30},
            {name = "Charlie", age = 35}
        }
        expect(
            chain(data):all(function(person)
                return person.age > 20
            end)
        ).to.equal(true)
        expect(
            chain(data):all(function(person)
                return person.age > 30
            end)
        ).to.equal(false)
    end)

    it("should throw an error when predicate is not a function", function()
        expect(function()
            chain({}):all("not a function")
        end).to.fail("all(pred): pred must be a function (got string: 'not a function')")
    end)

    it("should throw an error when predicate is missing", function()
        expect(function()
            chain({}):all()
        end).to.fail("all(pred): pred must be a function (got nil)")
    end)
end)
