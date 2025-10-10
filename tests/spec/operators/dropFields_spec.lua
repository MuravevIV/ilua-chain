local chain = require("chain")

describe("Chain:dropFields()", function()

    it("should raise an error when fieldsToDrop is not a table", function()
        expect(function()
            chain({1,2,3}):dropFields("not a table")
        end).to.fail("dropFields(fieldsToDrop): fieldsToDrop must be a table (got string: 'not a table')")
    end)

    it("should raise an error when fieldsToDrop is missing", function()
        expect(function()
            chain({1,2,3}):dropFields()
        end).to.fail("dropFields(fieldsToDrop): fieldsToDrop must be a table (got nil)")
    end)

    it("should preserve non-table elements", function()
        local data = {42, "apple", {"nested"}, 3.14, true}
        local dropped = chain(data):dropFields({"anyField"}):toList()
        -- Non-table items remain as they were
        expect(dropped[1]).to.equal(42)
        expect(dropped[2]).to.equal("apple")
        expect(dropped[3]).to.equal({"nested"})
        expect(dropped[4]).to.equal(3.14)
        expect(dropped[5]).to.equal(true)
    end)

    it("should remove specified fields from dictionary-like tables", function()
        local data = {
            {id=1, name="Alice", age=25},
            {id=2, name="Bob",   age=30, extra="ignore"},
            {id=3, age=40},
        }
        local dropped = chain(data):dropFields({"name", "extra"}):toList()

        -- Verify that "name" and "extra" are removed
        expect(dropped[1]).to.equal({id=1, age=25})
        expect(dropped[2]).to.equal({id=2, age=30})
        expect(dropped[3]).to.equal({id=3, age=40})
    end)

    it("should not fail if the field does not exist", function()
        local data = {
            {var1="one", var2="two"},
            {var1="foo"},
            {var2="bar"},
        }
        local dropped = chain(data):dropFields({"var3", "var1"}):toList()

        -- "var3" doesn't exist, so it does nothing; "var1" is dropped where it appears
        expect(dropped[1]).to.equal({var2="two"})
        expect(dropped[2]).to.equal({})
        expect(dropped[3]).to.equal({var2="bar"})
    end)

    it("should pass array-like tables through unchanged", function()
        local data = {
            { "alpha", "beta", "gamma" },
            99,
            { { nested = true }, "apple" }
        }
        -- Suppose your chain logic leaves array-like tables alone
        local dropped = chain(data):dropFields({"someField"}):toList()

        -- Confirm array-like tables remain untouched
        expect(dropped[1]).to.equal({ "alpha", "beta", "gamma" })
        expect(dropped[2]).to.equal(99)
        expect(dropped[3]).to.equal({ { nested = true }, "apple" })
    end)

    it("should not drop numeric keys from array-like tables", function()
        local data = {1, 2, 3}
        local selected = chain(data):dropFields({"1", 2}):toList()
        expect(selected).to.equal({1, 2, 3})
    end)
end)
