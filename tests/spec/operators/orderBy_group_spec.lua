local chain = require("chain")

describe("Chain:orderBy()", function()

    it("should sort chain elements by key function in ascending order", function()
        local data = {5, 3, 8, 1, 2}
        local result = chain(data):orderBy(function(x) return x end):toList()
        expect(result).to.equal({1, 2, 3, 5, 8})
    end)

    it("should sort using custom key extraction function", function()
        local data = {
            {name = "Charlie", age = 30},
            {name = "Alice", age = 25},
            {name = "Bob", age = 35}
        }

        -- Sort by name
        local byName = chain(data):orderBy(function(x) return x.name end):toList()
        expect(byName[1].name).to.equal("Alice")
        expect(byName[2].name).to.equal("Bob")
        expect(byName[3].name).to.equal("Charlie")

        -- Sort by age
        local byAge = chain(data):orderBy(function(x) return x.age end):toList()
        expect(byAge[1].age).to.equal(25)
        expect(byAge[2].age).to.equal(30)
        expect(byAge[3].age).to.equal(35)
    end)

    it("should maintain stability for equal keys", function()
        local data = {
            {group = "A", id = 1, pos = 1},
            {group = "B", id = 2, pos = 2},
            {group = "A", id = 3, pos = 3},
            {group = "C", id = 4, pos = 4},
            {group = "B", id = 5, pos = 5},
            {group = "C", id = 6, pos = 6},
            {group = "A", id = 7, pos = 7}
        }

        -- Sort by group
        local result = chain(data):orderBy(function(x) return x.group end):toList()

        -- Verify items with the same group remain in original order
        expect(result[1].id).to.equal(1)
        expect(result[2].id).to.equal(3)
        expect(result[3].id).to.equal(7)
        expect(result[4].id).to.equal(2)
        expect(result[5].id).to.equal(5)
        expect(result[6].id).to.equal(4)
        expect(result[7].id).to.equal(6)
    end)

end)

describe("Chain:orderByDesc()", function()

    it("should sort chain elements by key function in descending order", function()
        local data = {5, 3, 8, 1, 2}
        local result = chain(data):orderByDesc(function(x) return x end):toList()
        expect(result).to.equal({8, 5, 3, 2, 1})
    end)

    it("should maintain stability for equal keys in descending order", function()
        local data = {
            {group = "A", id = 1, pos = 1},
            {group = "A", id = 2, pos = 2},
            {group = "A", id = 3, pos = 3},
            {group = "B", id = 4, pos = 4},
            {group = "B", id = 5, pos = 5}
        }

        -- Sort by group descending, all 'A's should come after 'B's but preserve order among themselves
        local result = chain(data):orderByDesc(function(x) return x.group end):toList()

        -- B's come first, in original order
        expect(result[1].id).to.equal(4)
        expect(result[2].id).to.equal(5)
        -- A's follow, in original order
        expect(result[3].id).to.equal(1)
        expect(result[4].id).to.equal(2)
        expect(result[5].id).to.equal(3)
    end)

end)

describe("Chain:thenBy()", function()

    it("should allow multi-key ascending sort with stable results", function()
        local data = {
            {group = "A", name = "Bravo",   pos = 1},
            {group = "A", name = "Delta",   pos = 2},
            {group = "B", name = "Echo",    pos = 3},
            {group = "A", name = "Alpha",   pos = 4},
            {group = "B", name = "Charlie", pos = 5},
        }

        local result = chain(data)
                :orderBy(function(x) return x.group end)
                :thenBy(function(x) return x.name end)
                :toList()

        -- Groups sorted first: A's, then B's
        -- A's internally sorted by name in ascending order: Alpha, Bravo, Delta
        expect(result[1].name).to.equal("Alpha")
        expect(result[2].name).to.equal("Bravo")
        expect(result[3].name).to.equal("Delta")

        -- B's sorted by name ascending: Charlie, Echo
        expect(result[4].name).to.equal("Charlie")
        expect(result[5].name).to.equal("Echo")
    end)

    it("should maintain stability when second criterion is the same for some entries", function()
        local data = {
            {group = "A", name = "Same", pos = 1},
            {group = "A", name = "Same", pos = 2},
            {group = "B", name = "Diff", pos = 3},
            {group = "B", name = "Same", pos = 4},
            {group = "A", name = "Same", pos = 5},
        }

        local result = chain(data)
                :orderBy(function(x) return x.group end)
                :thenBy(function(x) return x.name end)
                :toList()

        -- Check A's in original order for those with identical name
        expect(result[1].pos).to.equal(1)
        expect(result[2].pos).to.equal(2)
        expect(result[3].pos).to.equal(5)
        -- Then B's follow
        expect(result[4].pos).to.equal(3)
        expect(result[5].pos).to.equal(4)
    end)

end)

describe("Chain:thenByDesc()", function()

    it("should allow multi-key sort, mixing ascending initial sort with descending second", function()
        local data = {
            {category = "C", value = 10, pos = 1},
            {category = "C", value = 10, pos = 2},
            {category = "B", value = 3,  pos = 3},
            {category = "C", value = 9,  pos = 4},
            {category = "B", value = 3,  pos = 5},
        }
        -- Sort by category ascending, then value descending
        local result = chain(data)
                :orderBy(function(x) return x.category end)
                :thenByDesc(function(x) return x.value end)
                :toList()

        -- B's first (sorted descending by value within B; but all have value=3, so stable)
        expect(result[1].pos).to.equal(3)
        expect(result[2].pos).to.equal(5)

        -- C's next, with descending value order
        -- All have value=10, except pos=4 with value=9
        -- So the pos=4 item should come last
        expect(result[3].pos).to.equal(1)
        expect(result[4].pos).to.equal(2)
        expect(result[5].pos).to.equal(4)
    end)

    it("should preserve original order among items that tie on second criterion", function()
        local data = {
            {type = "X", rating = 5,  index = 1},
            {type = "Y", rating = 5,  index = 2},
            {type = "Y", rating = 5,  index = 3},
            {type = "X", rating = 10, index = 4},
        }

        -- First sort ascending by type, then descending by rating
        local result = chain(data)
                :orderBy(function(x) return x.type end)
                :thenByDesc(function(x) return x.rating end)
                :toList()

        -- 'X' items come first, with rating descending among X
        -- X at rating=10 is first, then X at rating=5
        expect(result[1].index).to.equal(4)
        expect(result[2].index).to.equal(1)

        -- Then 'Y' items, rating=5 among them is the same, so preserve their original order
        expect(result[3].index).to.equal(2)
        expect(result[4].index).to.equal(3)
    end)
end)

describe("chain sorting scope", function()

    it("should not share sorting state (_sortFunctions) across different chain instances", function()
        local dataA = {3, 1, 2}
        local dataB = {6, 5, 4}

        -- chainA: call orderBy
        local chainA = chain(dataA):orderBy(function(x) return x end)
        local resultA = chainA:toList()
        -- Ascending sort for dataA => {1, 2, 3}
        expect(resultA).to.equal({1, 2, 3})

        -- chainB: attempt thenBy without prior orderBy/orderByDesc on dataB
        local success, errorMsg = pcall(function()
            -- thenBy should fail if there's no initial sort state
            chain(dataB):thenBy(function(x) return x end)
        end)

        -- We expect pcall to fail, because _sortFunctions isn’t set on a new chain
        expect(success).to.equal(false)
        expect(type(errorMsg)).to.equal("string")
    end)
end)
