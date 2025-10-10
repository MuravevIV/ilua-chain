local chain = require("chain")

describe("Chain:selectFields()", function()

    it("should raise an error when fieldsToSelect is not a table", function()
        expect(function()
            chain({1,2,3}):selectFields("not a table")
        end).to.fail("selectFields(fieldsToSelect): fieldsToSelect must be a table (got string: 'not a table')")
    end)

    it("should raise an error when fieldsToSelect is missing", function()
        expect(function()
            chain({1,2,3}):selectFields()
        end).to.fail("selectFields(fieldsToSelect): fieldsToSelect must be a table (got nil)")
    end)

    it("should preserve non-table elements", function()
        local data = {42, "apple", {"nested"}, 3.14, true}
        local selected = chain(data):selectFields({"doesNotExist"}):toList()
        -- Non-table items remain as they were
        expect(selected[1]).to.equal(42)
        expect(selected[2]).to.equal("apple")
        expect(selected[3]).to.equal({"nested"})
        expect(selected[4]).to.equal(3.14)
        expect(selected[5]).to.equal(true)
    end)

    it("should create new tables with only the selected fields", function()
        local data = {
            {id=1, name="Alice", age=25},
            {id=2, name="Bob",   age=30, extra="ignore"},
            {id=3, age=40},
        }
        local selected = chain(data):selectFields({"name", "age"}):toList()

        -- Check result structure
        expect(selected[1]).to.equal({name="Alice", age=25})
        expect(selected[2]).to.equal({name="Bob",   age=30})
        expect(selected[3]).to.equal({age=40})
    end)

    it("should ignore fields not present in individual tables", function()
        local data = {
            {var1="one", var2="two"},
            {var1="foo"},
            {var2="bar"},
        }
        local selected = chain(data):selectFields({"var1", "var2"}):toList()

        -- Check that missing fields do not appear
        expect(selected[1]).to.equal({var1="one", var2="two"})
        expect(selected[2]).to.equal({var1="foo"})
        expect(selected[3]).to.equal({var2="bar"})
    end)

    it("should not select numeric keys from array-like tables", function()
        local data = {1, 2, 3}
        local selected = chain(data):selectFields({"1", 2}):toList()
        expect(selected).to.equal({1, 2, 3})
    end)
end)
