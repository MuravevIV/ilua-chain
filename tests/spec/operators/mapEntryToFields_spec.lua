local chain = require("chain")

describe("Chain:mapEntryToFields()", function()

    it("transforms a map into a sequence of objects with specified fields", function()
        local data = {
            a = 1,
            b = 2,
            c = 3
        }
        local result = chain(data):mapEntryToFields("k", "v"):toList()

        -- Result should be a sequence
        expect(#result).to.equal(3)

        -- Check that all entries are present with correct fields
        local foundEntries = {
            a = false,
            b = false,
            c = false
        }

        for _, item in ipairs(result) do
            expect(item.k).to_not.be(nil)
            expect(item.v).to_not.be(nil)

            foundEntries[item.k] = true
            expect(item.v).to.equal(data[item.k])
        end

        -- Verify all keys were processed
        expect(foundEntries.a).to.equal(true)
        expect(foundEntries.b).to.equal(true)
        expect(foundEntries.c).to.equal(true)
    end)

    -- todo! fix test
--[[    it("handles different value types correctly", function()
        local data = {
            str = "string value",
            num = 42,
            bool = true,
            tbl = {nested = "value"},
            func = function() return "test" end
        }

        local result = chain(data):mapEntryToFields("name", "value"):collect()

        -- Check count
        expect(#result).to.equal(5)

        -- Verify all types were preserved correctly
        local typeFound = {
            string = false,
            number = false,
            boolean = false,
            table = false,
            ["function"] = false
        }

        for _, item in ipairs(result) do
            local valueType = type(item.value)
            typeFound[valueType] = true

            if item.name == "str" then
                expect(item.value).to.equal("string value")
            elseif item.name == "num" then
                expect(item.value).to.equal(42)
            elseif item.name == "bool" then
                expect(item.value).to.equal(true)
            elseif item.name == "tbl" then
                expect(type(item.value)).to.equal("table")
                expect(item.value.nested).to.equal("value")
            elseif item.name == "func" then
                expect(type(item.value)).to.equal("function")
                expect(item.value()).to.equal("test")
            end
        end

        -- Verify all types were processed
        for t, found in pairs(typeFound) do
            expect(found).to.equal(true, "Missing type: " .. t)
        end
    end)]]

    it("returns an empty sequence for an empty input map", function()
        local data = {}
        local result = chain(data):mapEntryToFields("key", "value"):toList()

        expect(result).to.equal({})
    end)

    it("throws an error if fieldKey is not a non-empty string", function()
        expect(function()
            chain({a = 1}):mapEntryToFields(nil, "value")
        end).to.fail("mapEntryToFields(fieldKey, fieldValue): fieldKey must be a non-empty string (got nil)")

        expect(function()
            chain({a = 1}):mapEntryToFields("", "value")
        end).to.fail("mapEntryToFields(fieldKey, fieldValue): fieldKey must be a non-empty string (got an empty string: '')")

        expect(function()
            chain({a = 1}):mapEntryToFields({}, "value")
        end).to.fail("mapEntryToFields(fieldKey, fieldValue): fieldKey must be a non-empty string (got table)")

        expect(function()
            chain({a = 1}):mapEntryToFields(123, "value")
        end).to.fail("mapEntryToFields(fieldKey, fieldValue): fieldKey must be a non-empty string (got number: 123)")
    end)

    it("throws an error if fieldValue is not a non-empty string", function()
        expect(function()
            chain({a = 1}):mapEntryToFields("key", nil)
        end).to.fail("mapEntryToFields(fieldKey, fieldValue): fieldValue must be a non-empty string (got nil)")

        expect(function()
            chain({a = 1}):mapEntryToFields("key", "")
        end).to.fail("mapEntryToFields(fieldKey, fieldValue): fieldValue must be a non-empty string (got an empty string: '')")

        expect(function()
            chain({a = 1}):mapEntryToFields("key", {})
        end).to.fail("mapEntryToFields(fieldKey, fieldValue): fieldValue must be a non-empty string (got table)")

        expect(function()
            chain({a = 1}):mapEntryToFields("key", 123)
        end).to.fail("mapEntryToFields(fieldKey, fieldValue): fieldValue must be a non-empty string (got number: 123)")
    end)

    it("does not mutate the original chain data", function()
        local data = { x = 100, y = 200 }
        local originalChain = chain(data)
        local modifiedChain = originalChain:mapEntryToFields("name", "value")

        local originalMap = originalChain:toMap()

        -- Original should remain unchanged
        expect(originalMap.x).to.equal(100)
        expect(originalMap.y).to.equal(200)

        -- Transformed should be a sequence of tables
        expect(modifiedChain:count()).to.equal(2) -- todo!
    end)

    it("handles fieldKey and fieldValue being the same", function()
        local data = { a = "a", b = "different" }

        -- Using the same field name for both key and value
        local result = chain(data):mapEntryToFields("field", "field"):toList()

        -- The value should override the key since it"s assigned second
        expect(#result).to.equal(2)

        for _, item in ipairs(result) do
            if item.field == "a" or item.field == "different" then
                -- Field value took precedence
                expect(true).to.equal(true)
            else
                -- This should not happen
                expect(false).to.equal(true, "Unexpected field value: " .. tostring(item.field))
            end
        end
    end)

    it("preserves key types as they are", function()
        local numKey = 123
        local boolKey = true

        local data = {
            ["string"] = "value1",
            [numKey] = "value2",
            [boolKey] = "value3"
        }

        local result = chain(data):mapEntryToFields("k", "v"):toList()

        -- Should have 3 items
        expect(#result).to.equal(3)

        local keyTypes = {
            string = false,
            number = false,
            boolean = false
        }

        for _, item in ipairs(result) do
            keyTypes[type(item.k)] = true

            if item.k == "string" then
                expect(item.v).to.equal("value1")
            elseif item.k == numKey then
                expect(item.v).to.equal("value2")
            elseif item.k == boolKey then
                expect(item.v).to.equal("value3")
            end
        end

        -- Verify all key types were preserved
        expect(keyTypes.string).to.equal(true)
        expect(keyTypes.number).to.equal(true)
        expect(keyTypes.boolean).to.equal(true)
    end)

    it("each entry is a new table instance", function()
        local data = { a = 1, b = 2 }
        local result = chain(data):mapEntryToFields("key", "val"):toList()

        expect(#result).to.equal(2)
        expect(result[1]).to_not.be(result[2])
    end)
end)
