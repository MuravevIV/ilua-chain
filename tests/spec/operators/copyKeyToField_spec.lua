local chain = require 'chain'  -- Adjust require path as needed.

describe('Chain:copyKeyToField()', function()

    it('adds the original key to the table under the specified field name', function()
        local data = {
            a = { a1 = 1, a2 = 2 },
            b = { b1 = 3, b2 = 4 },
        }
        local result = chain(data):copyKeyToField('ref'):toMap()

        expect(result.a.ref).to.equal('a')
        expect(result.b.ref).to.equal('b')
    end)

    it('does not alter values that are not tables', function()
        local data = {
            x = 100,
            y = 'some text'
        }
        local result = chain(data):copyKeyToField('ref'):toMap()

        -- Verify original non-table values are unchanged
        expect(result.x).to.equal(100)
        expect(result.y).to.equal('some text')

        -- Since x and y are not tables, "ref" should not exist
        -- (and we avoid indexing result.x.ref which would cause an error)
        expect(type(result.x)).to.equal('number')
        expect(type(result.y)).to.equal('string')
    end)

    it('preserves all original keys and values in the resulting map', function()
        local data = {
            key1 = { info = 'alpha' },
            key2 = { info = 'beta' },
            key3 = 'plain string',
            key4 = 99
        }
        local result = chain(data):copyKeyToField('myKey'):toMap()

        -- Check table-like values
        expect(result.key1.info).to.equal('alpha')
        expect(result.key1.myKey).to.equal('key1')
        expect(result.key2.info).to.equal('beta')
        expect(result.key2.myKey).to.equal('key2')

        -- Check non-table values still in place
        expect(result.key3).to.equal('plain string')
        expect(result.key4).to.equal(99)
    end)

    it('throws an error if fieldName is not a non-empty string', function()
        expect(function()
            chain({}):copyKeyToField(nil)
        end).to.fail("copyKeyToField(fieldName): fieldName must be a non-empty string (got nil)")

        expect(function()
            chain({}):copyKeyToField('')
        end).to.fail("copyKeyToField(fieldName): fieldName must be a non-empty string (got an empty string: '')")

        expect(function()
            chain({}):copyKeyToField({})
        end).to.fail("copyKeyToField(fieldName): fieldName must be a non-empty string (got table)")
    end)

    it('does not mutate the original chain data', function()
        local data = { a = { someValue = 123 } }
        local s1 = chain(data)
        local s2 = s1:copyKeyToField('newField')

        local original = s1:toMap()
        local modified = s2:toMap()

        -- The original should remain unchanged (no "newField" key).
        expect(original.a.newField).to_not.exist()

        -- The new chain should have the added field.
        expect(modified.a.newField).to.equal('a')
    end)

    it('replaces existing field when fieldName already exists in the value table', function()
        local data = {
            a = { a1 = 1, a2 = 2, ref = "original value" },
            b = { b1 = 3, b2 = 4, ref = 999 }
        }

        local result = chain(data):copyKeyToField('ref'):toMap()

        -- The original "ref" values should be replaced with the keys
        expect(result.a.ref).to.equal('a')  -- Was "original value" before
        expect(result.b.ref).to.equal('b')  -- Was 999 before

        -- Other fields should remain unchanged
        expect(result.a.a1).to.equal(1)
        expect(result.a.a2).to.equal(2)
        expect(result.b.b1).to.equal(3)
        expect(result.b.b2).to.equal(4)

        -- Original data should not be modified
        expect(data.a.ref).to.equal("original value")
        expect(data.b.ref).to.equal(999)
    end)
end)
