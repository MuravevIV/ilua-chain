local chain = require("chain")

describe("Chain:moveFieldToKey()", function()

    it("transforms each table into a map keyed by the specified field, removing that field from the table", function()
        local data = {
            {id = 1, name = "Alice"},
            {id = 2, name = "Bob"},
            {id = 3, name = "Charlie"}
        }

        local result = chain(data):moveFieldToKey("id"):toList()

        -- We expect a table keyed by id
        expect(result[1]).to_not.equal(nil)
        expect(result[1].id).to.equal(nil) -- Field is removed
        expect(result[1].name).to.equal("Alice")

        expect(result[2]).to_not.equal(nil)
        expect(result[2].id).to.equal(nil)
        expect(result[2].name).to.equal("Bob")

        expect(result[3]).to_not.equal(nil)
        expect(result[3].id).to.equal(nil)
        expect(result[3].name).to.equal("Charlie")

        -- No other keys
        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(3)
    end)

    it("skips non-table elements", function()
        local data = {
            42,
            "some string",
            {id = 1, name = "Alice"}
        }

        local result = chain(data):moveFieldToKey("id"):toList()
        -- Only the table element that has an `id` field
        expect(result[1]).to_not.equal(nil)
        expect(result[1].name).to.equal("Alice")
        expect(result[1].id).to.equal(nil)

        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(1)
    end)

    it("skips table elements that don't have the specified field", function()
        local data = {
            {id = 1, name = "Alice"},
            {name = "Bob"}, -- Missing id
            {id = 2, other = true}
        }

        local result = chain(data):moveFieldToKey("id"):toList()

        -- 'Bob' is skipped
        expect(result[1]).to_not.equal(nil)
        expect(result[2]).to_not.equal(nil)
        expect(result[3]).to.equal(nil)

        -- Field is removed in the resulting entries
        expect(result[1].id).to.equal(nil)
        expect(result[2].id).to.equal(nil)

        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(2)
    end)

    it("preserves the first occurrence when duplicates exist for the specified field", function()
        local data = {
            {id = 1, name = "First"},
            {id = 2, name = "Second"},
            {id = 1, name = "Duplicate"} -- same id as 'First'
        }

        local result = chain(data):moveFieldToKey("id"):toList()

        -- 'id=1' should hold "First" (the first occurrence)
        expect(result[1].name).to.equal("First")
        expect(result[2].name).to.equal("Second")

        -- Both should have no 'id' in their table
        expect(result[1].id).to.equal(nil)
        expect(result[2].id).to.equal(nil)

        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(2)
    end)

    it("returns an empty map when none match", function()
        local data = {
            "string value",
            999,
            {x = 10}, -- no 'id' field
        }

        local result = chain(data):moveFieldToKey("id"):toList()
        expect(result).to.equal({})
    end)
end)
