local chain = require("chain")

describe("Chain:copyFieldToKey()", function()

    it("transforms a sequence of table elements keyed by the specified field", function()
        local data = {
            {id = 1, name = "Alice"},
            {id = 2, name = "Bob"},
            {id = 3, name = "Charlie"}
        }

        local result = chain(data):copyFieldToKey("id"):toList()

        -- We expect a table keyed by id
        expect(result[1].id).to.equal(1)
        expect(result[1].name).to.equal("Alice")
        expect(result[2].id).to.equal(2)
        expect(result[2].name).to.equal("Bob")
        expect(result[3].id).to.equal(3)
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

        local result = chain(data):copyFieldToKey("id"):toList()

        -- Only the table element that has an `id` field
        expect(result[1].name).to.equal("Alice")

        -- Non-table entries skipped
        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(1)
    end)

    it("skips table elements that don't have the specified field", function()
        local data = {
            {id = 1, name = "Alice"},
            {name = "Bob"},  -- Missing id
            {id = 2, other = true}
        }

        local result = chain(data):copyFieldToKey("id"):toList()

        -- Bob's entry is skipped
        expect(result[1]).to_not.equal(nil)
        expect(result[2]).to_not.equal(nil)
        expect(result[3]).to.equal(nil)  -- 3 is not a key in result

        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(2)
    end)

    it("preserves the first occurrence for duplicate field values", function()
        local data = {
            {id = 1, name = "First"},
            {id = 2, name = "Second"},
            {id = 1, name = "Duplicate"} -- same id as first
        }

        local result = chain(data):copyFieldToKey("id"):toList()

        -- `id=1` should hold "First" (the first occurrence)
        expect(result[1].name).to.equal("First")
        expect(result[2].name).to.equal("Second")

        -- Only 2 entries in the map
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
            {x = 10}, -- there's no "id" field
        }
        local result = chain(data):copyFieldToKey("id"):toList()
        expect(result).to.equal({})
    end)
end)
