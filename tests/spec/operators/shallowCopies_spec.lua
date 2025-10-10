local chain = require("chain")

describe("Chain:shallowCopies()", function()

    it("creates shallow copies of table elements", function()
        local table1 = {a = 1, b = 2}
        local table2 = {c = 3, d = 4}
        local data = {table1, table2}

        local result = chain(data):shallowCopies():toList()

        -- Result should contain different table references
        expect(result[1]).to_not.be(table1)
        expect(result[2]).to_not.be(table2)

        -- But with the same contents
        expect(result[1].a).to.equal(1)
        expect(result[1].b).to.equal(2)
        expect(result[2].c).to.equal(3)
        expect(result[2].d).to.equal(4)
    end)

    it("preserves non-table values as-is", function()
        local data = {"string", 42, true, {x = 10}}

        local result = chain(data):shallowCopies():toList()

        -- Non-table values should be identical
        expect(result[1]).to.equal("string")
        expect(result[2]).to.equal(42)
        expect(result[3]).to.equal(true)

        -- Table should be a shallow copy
        expect(result[4]).to_not.be(data[4])
        expect(result[4].x).to.equal(10)
    end)

    it("returns an empty chain when input is empty", function()
        local data = {}
        local result = chain(data):shallowCopies():toList()
        expect(result).to.equal({})
    end)

    it("creates shallow copies that don't affect originals when modified", function()
        local table1 = {value = 100}
        local data = {table1}

        local result = chain(data):shallowCopies():toList()

        -- Modify the copy
        result[1].value = 200
        result[1].newField = "added"

        -- Original should be unchanged
        expect(table1.value).to.equal(100)
        expect(table1.newField).to.equal(nil)

        -- Copy should have the changes
        expect(result[1].value).to.equal(200)
        expect(result[1].newField).to.equal("added")
    end)

    it("preserves nested tables as references (shallow copy)", function()
        local nested = {inner = "value"}
        local table1 = {name = "test", nested = nested}
        local data = {table1}

        local result = chain(data):shallowCopies():toList()

        -- The top-level object should be a different reference
        expect(result[1]).to_not.be(table1)

        -- But the nested object should be the same reference
        expect(result[1].nested).to.be(nested)

        -- Modifying the nested table should affect both copies
        nested.inner = "changed"
        expect(result[1].nested.inner).to.equal("changed")
    end)

    it("preserves the original element order", function()
        local data = {{id = 1}, {id = 2}, {id = 3}, {id = 4}, {id = 5}}

        local result = chain(data):shallowCopies():toList()

        expect(#result).to.equal(5)
        for i = 1, 5 do
            expect(result[i].id).to.equal(i)
        end
    end)
end)
