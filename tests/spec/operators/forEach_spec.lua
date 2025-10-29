local chain = require("chain")

describe("Chain:forEach()", function()

    it("should apply function to each element", function()
        local results = {}
        chain({1, 2, 3, 4, 5}):forEach(function(v)
            table.insert(results, v * 2)
        end)
        expect(results).to.equal({2, 4, 6, 8, 10})
    end)

    it("should provide correct key for each element", function()
        local data = {"a", "b", "c"}
        local keys = {}
        local values = {}
        chain(data):forEach(function(v, k)
            table.insert(values, v)
            table.insert(keys, k)
        end)
        expect(values).to.equal({"a", "b", "c"})
        expect(keys).to.equal({1, 2, 3})
    end)

    it("should return the original chain for method chaining", function()
        local data = {1, 2, 3}
        local sum = 0
        chain(data)
            :forEach(function(v) sum = sum + v end)
            :assertEquals(data)
        expect(sum).to.equal(6)
    end)

    it("should work with empty chain", function()
        local called = false
        chain({}):forEach(function() called = true end)
        expect(called).to.equal(false)
    end)

    it("should execute function exactly once per element", function()
        local count = 0
        chain({1, 2, 3, 4, 5}):forEach(function() count = count + 1 end)
        expect(count).to.equal(5)
    end)

    it("should throw error when actFunc is not a function", function()
        expect(function()
            chain({}):forEach("not a function")
        end).to.fail("forEach(actFn): actFn must be a function (got string: 'not a function')")
        expect(function()
            chain({}):forEach()
        end).to.fail("forEach(actFn): actFn must be a function (got nil)")
    end)

    it("should work with complex element types", function()
        local data = {
            {name = "Alice", age = 30},
            {name = "Bob", age = 25},
            {name = "Charlie", age = 35}
        }

        local names = {}
        local totalAge = 0

        chain(data):forEach(function(person)
            table.insert(names, person.name)
            totalAge = totalAge + person.age
        end)

        expect(names).to.equal({"Alice", "Bob", "Charlie"})
        expect(totalAge).to.equal(90)
    end)
end)
