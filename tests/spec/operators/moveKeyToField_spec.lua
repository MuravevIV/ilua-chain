local chain = require "chain"  -- Adjust require path as needed.

describe("Chain:moveKeyToField()", function()

    it("transforms map to sequence with keys stored in the specified field", function()
        local data = {
            a = { a1 = 1, a2 = 2 },
            b = { b1 = 3, b2 = 4 },
        }
        local result = chain(data):moveKeyToField("ref"):toList()

        -- Result should be a sequence (array)
        expect(#result).to.equal(2)

        -- Original keys should be stored in values
        local hasA = false
        local hasB = false

        for _, item in ipairs(result) do
            if item.ref == "a" then
                expect(item.a1).to.equal(1)
                expect(item.a2).to.equal(2)
                hasA = true
            elseif item.ref == "b" then
                expect(item.b1).to.equal(3)
                expect(item.b2).to.equal(4)
                hasB = true
            end
        end

        expect(hasA).to.equal(true)
        expect(hasB).to.equal(true)
    end)

    it("preserves non-table values as-is in the sequence", function()
        local data = {
            x = 100,
            y = "some text",
            z = { info = "data" }
        }
        local result = chain(data):moveKeyToField("ref"):toList()

        -- Should have 3 items in the sequence
        expect(#result).to.equal(3)

        -- Check for each possible value
        local foundNumber = false
        local foundString = false
        local foundTable = false

        for _, item in ipairs(result) do
            if type(item) == "number" and item == 100 then
                foundNumber = true
            elseif type(item) == "string" and item == "some text" then
                foundString = true
            elseif type(item) == "table" and item.info == "data" and item.ref == "z" then
                foundTable = true
            end
        end

        expect(foundNumber).to.equal(true)
        expect(foundString).to.equal(true)
        expect(foundTable).to.equal(true)
    end)

    it("throws an error if fieldName is not a non-empty string", function()
        expect(function()
            chain({}):moveKeyToField(nil)
        end).to.fail("moveKeyToField(fieldName): fieldName must be a non-empty string (got nil)")

        expect(function()
            chain({}):moveKeyToField("")
        end).to.fail("moveKeyToField(fieldName): fieldName must be a non-empty string (got an empty string: '')")

        expect(function()
            chain({}):moveKeyToField({})
        end).to.fail("moveKeyToField(fieldName): fieldName must be a non-empty string (got table)")
    end)

    it("does not mutate the original chain data", function()
        local data = { a = { someValue = 123 } }
        local s1 = chain(data)
        local s2 = s1:moveKeyToField("newField")

        local original = s1:toMap()
        local modified = s2:toList()

        -- The original should remain unchanged
        expect(original.a.newField).to_not.exist()
        expect(original.a.someValue).to.equal(123)

        -- The new chain should be a sequence with the added field
        expect(#modified).to.equal(1)
        expect(modified[1].newField).to.equal("a")
        expect(modified[1].someValue).to.equal(123)
    end)

    it("replaces existing field when fieldName already exists in the value table", function()
        local data = {
            a = { a1 = 1, a2 = 2, ref = "original value" },
            b = { b1 = 3, b2 = 4, ref = 999 }
        }

        local result = chain(data):moveKeyToField("ref"):toList()

        -- Result should be a sequence with 2 elements
        expect(#result).to.equal(2)

        -- Find and verify both objects
        local foundA = false
        local foundB = false

        for _, item in ipairs(result) do
            if item.ref == "a" then
                expect(item.a1).to.equal(1)
                expect(item.a2).to.equal(2)
                foundA = true
            elseif item.ref == "b" then
                expect(item.b1).to.equal(3)
                expect(item.b2).to.equal(4)
                foundB = true
            end
        end

        expect(foundA).to.equal(true)
        expect(foundB).to.equal(true)

        -- Original data should not be modified
        expect(data.a.ref).to.equal("original value")
        expect(data.b.ref).to.equal(999)
    end)

    it("returns an empty sequence for an empty input map", function()
        local data = {}
        local result = chain(data):moveKeyToField("ref"):toList()

        expect(result).to.equal({})
    end)

    it("handles mixed data types correctly", function()
        local data = {
            key1 = { info = "alpha" },
            key2 = "plain string",
            key3 = 42,
            key4 = true,
            key5 = { nested = { deep = "value" } }
        }

        local result = chain(data):moveKeyToField("source"):toList()

        -- Should have 5 items
        expect(#result).to.equal(5)

        -- Count occurrences of each type
        local tableCount = 0
        local stringCount = 0
        local numberCount = 0
        local boolCount = 0

        for _, item in ipairs(result) do
            if type(item) == "table" then
                tableCount = tableCount + 1
                if item.info == "alpha" then
                    expect(item.source).to.equal("key1")
                elseif item.nested then
                    expect(item.source).to.equal("key5")
                    expect(item.nested.deep).to.equal("value")
                end
            elseif type(item) == "string" then
                stringCount = stringCount + 1
                expect(item).to.equal("plain string")
            elseif type(item) == "number" then
                numberCount = numberCount + 1
                expect(item).to.equal(42)
            elseif type(item) == "boolean" then
                boolCount = boolCount + 1
                expect(item).to.equal(true)
            end
        end

        expect(tableCount).to.equal(2)
        expect(stringCount).to.equal(1)
        expect(numberCount).to.equal(1)
        expect(boolCount).to.equal(1)
    end)
end)
