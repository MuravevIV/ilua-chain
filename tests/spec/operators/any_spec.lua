local chain = require("chain")

describe("Chain:any()", function()

    it("should return true if any element matches the predicate", function()
        local result = chain({ 1, 2, 3, 4, 5}):any(function(v) return v > 3 end)
        expect(result).to.equal(true)
    end)

    it("should return false if no element matches the predicate", function()
        local result = chain({ 1, 2, 3, 4, 5}):any(function(v) return v > 10 end)
        expect(result).to.equal(false)
    end)

    it("should return true when no predicate is provided and collection is non-empty", function()
        local result = chain({ 1 }):any()
        expect(result).to.equal(true)
    end)

    it("should return true when no predicate is provided and collection is empty", function()
        local result = chain({}):any()
        expect(result).to.equal(false)
    end)

    it("should provide correct key to predicate function", function()
        local indices = {}
        chain({ a = 10, b = 20, c = 30}):any(function(_, k)
            table.insert(indices, k)
            return false
        end)
        expect(indices).to.equal({"a", "b", "c"})
    end)

    it("should provide correct index to predicate function", function()
        local indices = {}
        chain({a = 10, b = 20, c = 30}):any(function(_, _, idx)
            table.insert(indices, idx)
            return false
        end)
        expect(indices).to.equal({1, 2, 3})
    end)

    it("should return false for empty chain", function()
        local result = chain({}):any(function(v) return v > 0 end)
        expect(result).to.equal(false)
    end)

    it("should handle single element chain", function()
        local data = {42}
        local anyPositive = chain(data):any(function(v) return v > 0 end)
        local anyNegative = chain(data):any(function(v) return v < 0 end)
        expect(anyPositive).to.equal(true)
        expect(anyNegative).to.equal(false)
    end)

    it("should short-circuit when match is found", function()
        local visited = 0
        local result = chain({1, 2, 3, 4, 5}):any(function(v)
            visited = visited + 1
            return v == 3
        end)
        expect(result).to.equal(true)
        expect(visited).to.equal(3)
    end)

    it("should evaluate all elements when predicate always returns false", function()
        local visited = 0
        local result = chain({1, 2, 3, 4, 5}):any(function(v)
            visited = visited + 1
            return v > 5
        end)
        expect(result).to.equal(false)
        expect(visited).to.equal(5)
    end)

    it("should work with complex element types", function()
        local data = {
            {name = "Alice", age = 30},
            {name = "Bob", age = 25},
            {name = "Charlie", age = 35}
        }
        local hasOver30 = chain(data):any(function(person)
            return person.age > 30
        end)
        local hasJohn = chain(data):any(function(person)
            return person.name == "John"
        end)
        expect(hasOver30).to.equal(true)
        expect(hasJohn).to.equal(false)
    end)

    it("should throw an error when predicate is not a function", function()
        expect(function()
            chain({}):any("not a function")
        end).to.fail("any(pred): pred must be a function or nil (got string: 'not a function')")
    end)
end)
