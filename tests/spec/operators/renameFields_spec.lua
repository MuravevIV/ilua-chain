local chain = require("chain")

describe("Chain:renameFields()", function()

    it("should raise an error when renameMap is not a table", function()
        expect(function()
            chain({1,2,3}):renameFields("not a table")
        end).to.fail("renameFields(renameMap): renameMap must be a table (got string: 'not a table')")
    end)

    it("should raise an error when renameMap is missing", function()
        expect(function()
            chain({1,2,3}):renameFields()
        end).to.fail("renameFields(renameMap): renameMap must be a table (got nil)")
    end)

    it("should pass through non-table elements unchanged", function()
        local data = {42, "banana", true}
        local renamed = chain(data):renameFields({oldField="newField"}):toList()

        expect(renamed[1]).to.equal(42)
        expect(renamed[2]).to.equal("banana")
        expect(renamed[3]).to.equal(true)
    end)

    it("should rename specified fields in dictionary-like tables", function()
        local data = {
            {id=1, oldField="oldValue", keep="keepMe"},
            {id=2, oldField="anotherValue", extra="extraField"}
        }

        local renameMap = { oldField = "newField" }
        local renamed = chain(data):renameFields(renameMap):toList()

        expect(renamed[1]).to.equal({id=1, newField="oldValue", keep="keepMe"})
        expect(renamed[2]).to.equal({id=2, newField="anotherValue", extra="extraField"})
    end)

    it("should ignore fields that do not exist in a table", function()
        local data = {
            {var1="one", var2="two"},
            {var1="foo"},
            {var2="bar"}
        }

        local renamed = chain(data):renameFields({ var1="primary", var3="something" }):toList()

        expect(renamed[1]).to.equal({primary="one", var2="two"})
        expect(renamed[2]).to.equal({primary="foo"})
        expect(renamed[3]).to.equal({var2="bar"})
    end)

    it("should handle renaming multiple fields in the same table", function()
        local data = {
            {oldA="Alpha", oldB="Beta"},
            {oldA="Gamma"}
        }
        local renameMap = { oldA="newA", oldB="newB" }
        local renamed = chain(data):renameFields(renameMap):toList()

        expect(renamed[1]).to.equal({newA="Alpha", newB="Beta"})
        expect(renamed[2]).to.equal({newA="Gamma"})
    end)

    it("should preserve numeric keys but rename string keys in mixed tables", function()
        local data = {
            {[1]="first", [2]="second", oldKey="oldValue"},
            {3, 4, oldKey="shouldRename"}
        }
        local renameMap = { [2]=20, oldKey="newKey" }
        local renamed = chain(data):renameFields(renameMap):toList()

        -- The first element is dictionary-like but includes numeric keys
        expect(renamed[1][1]).to.equal("first")
        expect(renamed[1][2]).to.equal("second")          -- numeric key remains 2
        expect(renamed[1].newKey).to.equal("oldValue")    -- string key renamed

        -- The second element is array-like
        expect(renamed[2][1]).to.equal(3)
        expect(renamed[2][2]).to.equal(4)                 -- numeric key remains 2
        expect(renamed[2].newKey).to.equal("shouldRename") -- string key renamed
    end)
end)
