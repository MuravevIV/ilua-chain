local xtable = require("src.xtable") -- Assuming xtable.lua is in the Lua path or same directory

describe("xtable - Construction and Initialization", function()

    describe("xtable.new()", function()
        it("should create an empty xtable", function()
            local xt = xtable.new()

            expect(xt).to.exist()
            expect(xt).to.be.a(xtable) -- Check if it's an instance of xtable

            expect(#xt).to.equal(0)
            expect(xt:len()).to.equal(0)
            expect(xt:count()).to.equal(0)

            expect(xt:toMap()).to.equal({})
            expect(xt:toList()).to.equal({})

            -- Optionally check internal state if considered part of the public contract for testing
            -- For a black-box test, the above toMap/toList checks might be sufficient.
            -- However, knowing the structure can help confirm initialization.
            expect(rawget(xt, "_nodes")).to.equal({})
            expect(rawget(xt, "_nKey_to_iKey")).to.equal({})
        end)
    end)

    describe("xtable.fromUPairs()", function()

        it("should create an empty xtable from an empty table input", function()
            local xt = xtable.fromUPairs({})
            expect(#xt).to.equal(0)
            expect(xt:toMap()).to.equal({})
        end)

        it("should create an xtable from a non-empty table", function()
            local data = {
                [1] = "alpha",
                ["key2"] = "beta",
                [true] = "gamma"
            }
            local xt = xtable.fromUPairs(data)

            expect(#xt).to.equal(3)

            -- Verify content using toMap as iKey order is not guaranteed by fromUPairs
            expect(xt:toMap()).to.equal(data)

            -- Verify individual items can be retrieved by their nKey
            local val1 = xt:getByNKey(1)
            expect(val1).to.equal("alpha")

            local val2 = xt:getByNKey("key2")
            expect(val2).to.equal("beta")

            local val3 = xt:getByNKey(true)
            expect(val3).to.equal("gamma")
        end)
    end)

    describe("xtable.fromOPairs()", function()

        it("should create an empty xtable from an empty table input", function()
            local xt = xtable.fromOPairs({})
            expect(#xt).to.equal(0)
            expect(xt:toMap()).to.equal({})
        end)

        it("should create an xtable with deterministic order from a mixed-key table", function()
            local data = {
                ["charlie"] = { value = 300 },
                [1] = { value = 100 },
                [false] = { value = 0 },
                ["alpha"] = { value = 400 },
                [10] = { value = 200 },
                [true] = { value = 1 }
            }
            -- Expected order by opairs_key_comparator:
            -- Numbers: 1, 10
            -- Strings: "alpha", "charlie"
            -- Booleans: false, true
            local expected_list_values = {
                { value = 100 },  -- nKey: 1
                { value = 200 },  -- nKey: 10
                { value = 400 },  -- nKey: "alpha"
                { value = 300 },  -- nKey: "charlie"
                { value = 0 },    -- nKey: false
                { value = 1 }     -- nKey: true
            }
            local expected_nKeys_by_iKey = {
                [1] = 1,
                [2] = 10,
                [3] = "alpha",
                [4] = "charlie",
                [5] = false,
                [6] = true
            }

            local xt = xtable.fromOPairs(data)

            expect(#xt).to.equal(6)
            expect(xt:toMap()).to.equal(data) -- toMap should still reflect original key-value pairs
            expect(xt:toList()).to.equal(expected_list_values) -- toList reflects the iKey order

            for iKey, expected_nKey in pairs(expected_nKeys_by_iKey) do
                local nKey_actual = xt:getNKeyByIKey(iKey)
                local value_actual_by_iKey = xt:getByIKey(iKey)
                local value_actual_by_nKey = xt:getByNKey(expected_nKey)

                expect(nKey_actual).to.be(expected_nKey) -- Use 'to.be' for strict boolean comparison
                expect(value_actual_by_iKey).to.equal(data[expected_nKey])
                expect(value_actual_by_nKey).to.equal(data[expected_nKey])
            end
        end)
    end)
end)

describe("xtable - Insertion, Getters, and Length", function()
    local xt

    before(function()
        xt = xtable.new()
    end)

    describe("xtable:insert()", function()
        it("should insert a new item and return its iKey", function()
            local iKey1 = xt:insert("key1", "value1")
            expect(iKey1).to.equal(1)
            expect(#xt).to.equal(1)
            expect(xt:getByIKey(1)).to.equal("value1")
            expect(xt:getNKeyByIKey(1)).to.equal("key1")
            expect(xt:getByNKey("key1")).to.equal("value1")
            expect(xt:getIKeyByNKey("key1")).to.equal(1)

            local iKey2 = xt:insert(2, "value2")
            expect(iKey2).to.equal(2)
            expect(#xt).to.equal(2)
            expect(xt:getByIKey(2)).to.equal("value2")
            expect(xt:getNKeyByIKey(2)).to.equal(2)
            expect(xt:getByNKey(2)).to.equal("value2")
            expect(xt:getIKeyByNKey(2)).to.equal(2)
        end)

        it("should upsert an existing item by nKey and return its existing iKey", function()
            local iKey_initial = xt:insert("key1", "value_initial")
            expect(iKey_initial).to.equal(1)
            expect(#xt).to.equal(1)

            local iKey_upsert = xt:insert("key1", "value_updated")
            expect(iKey_upsert).to.equal(iKey_initial) -- Should be the same iKey
            expect(#xt).to.equal(1) -- Length should not change

            expect(xt:getByIKey(1)).to.equal("value_updated")
            expect(xt:getNKeyByIKey(1)).to.equal("key1")
            expect(xt:getByNKey("key1")).to.equal("value_updated")
            expect(xt:getIKeyByNKey("key1")).to.equal(1)
        end)

        it("should correctly increment iKeys for multiple distinct insertions", function()
            xt:insert("a", 10) -- iKey 1
            xt:insert("b", 20) -- iKey 2
            xt:insert("c", 30) -- iKey 3

            expect(#xt).to.equal(3)
            expect(xt:getIKeyByNKey("a")).to.equal(1)
            expect(xt:getIKeyByNKey("b")).to.equal(2)
            expect(xt:getIKeyByNKey("c")).to.equal(3)

            expect(xt:getNKeyByIKey(1)).to.equal("a")
            expect(xt:getNKeyByIKey(2)).to.equal("b")
            expect(xt:getNKeyByIKey(3)).to.equal("c")
        end)
    end)

    describe("Getters (getByIKey, getByNKey, getIKeyByNKey, getNKeyByIKey)", function()
        before(function()
            -- Populate for getter tests
            xt:insert(100, "apple")     -- iKey 1
            xt:insert("banana_key", "banana_val") -- iKey 2
            xt:insert(true, "boolean_true_val") -- iKey 3
        end)

        it("getByIKey: should return value and nKey for a valid iKey", function()
            local val, nKey = xt:getByIKey(2)
            expect(val).to.equal("banana_val")
            expect(nKey).to.equal("banana_key")
        end)

        it("getByIKey: should return nil for an out-of-bounds iKey", function()
            expect(xt:getByIKey(0)).to_not.exist()
            expect(xt:getByIKey(4)).to_not.exist()
            local val, nKey = xt:getByIKey(4)
            expect(val).to_not.exist()
            expect(nKey).to_not.exist()
        end)

        it("getByNKey: should return value and iKey for a valid nKey", function()
            local val, _, iKey = xt:getByNKey("banana_key")
            expect(val).to.equal("banana_val")
            expect(iKey).to.equal(2)
        end)

        it("getByNKey: should return nil for a non-existent nKey", function()
            expect(xt:getByNKey("non_existent_key")).to_not.exist()
            local val, iKey = xt:getByNKey("non_existent_key")
            expect(val).to_not.exist()
            expect(iKey).to_not.exist()
        end)

        it("getIKeyByNKey: should return iKey for a valid nKey", function()
            expect(xt:getIKeyByNKey(100)).to.equal(1)
            expect(xt:getIKeyByNKey(true)).to.equal(3)
        end)

        it("getIKeyByNKey: should return nil for a non-existent nKey", function()
            expect(xt:getIKeyByNKey("grape")).to_not.exist()
        end)

        it("getNKeyByIKey: should return nKey for a valid iKey", function()
            expect(xt:getNKeyByIKey(1)).to.equal(100)
            expect(xt:getNKeyByIKey(3)).to.be(true) -- use 'be' for strict boolean check
        end)

        it("getNKeyByIKey: should return nil for an out-of-bounds iKey", function()
            expect(xt:getNKeyByIKey(0)).to_not.exist()
            expect(xt:getNKeyByIKey(5)).to_not.exist()
        end)
    end)

    describe("Length operations (:len(), :count(), #)", function()
        it("should report 0 for a new xtable", function()
            expect(#xt).to.equal(0)
            expect(xt:len()).to.equal(0)
            expect(xt:count()).to.equal(0)
        end)

        it("should update length after insertions", function()
            xt:insert("one", 1)
            expect(#xt).to.equal(1)
            xt:insert("two", 2)
            expect(xt:len()).to.equal(2)
            xt:insert("three", 3)
            expect(xt:count()).to.equal(3)
        end)

        it("should not change length on upsert", function()
            xt:insert("one", 1)
            xt:insert("two", 2)
            expect(#xt).to.equal(2)
            xt:insert("one", "updated_one") -- Upsert
            expect(#xt).to.equal(2)
        end)
    end)

end)

describe("xtable - Modification (setByIKey, setByNKey)", function()
    local xt

    before(function()
        xt = xtable.new()
        xt:insert("nKeyA", "valueA_initial") -- iKey 1
        xt:insert(123, "valueB_initial")     -- iKey 2
        xt:insert(true, "valueC_initial")    -- iKey 3
    end)

    describe("xtable:setByIKey()", function()
        it("should update the value at the specified iKey and return true", function()
            local success = xt:setByIKey(2, "valueB_updated_by_iKey")
            expect(success).to.be(true)

            local val, nKey = xt:getByIKey(2)
            expect(val).to.equal("valueB_updated_by_iKey")
            expect(nKey).to.equal(123) -- nKey should remain unchanged

            -- Verify other elements are unaffected
            expect(xt:getByIKey(1)).to.equal("valueA_initial")
            expect(xt:getByNKey(true)).to.equal("valueC_initial")
            expect(#xt).to.equal(3) -- Length should remain unchanged
        end)

        it("should not change the nKey associated with the iKey", function()
            xt:setByIKey(1, "valueA_updated_again")
            expect(xt:getNKeyByIKey(1)).to.equal("nKeyA")
        end)

        it("should return false if iKey is out of bounds (too low)", function()
            local success = xt:setByIKey(0, "attempt_fail")
            expect(success).to.be(false)
            expect(xt:getByIKey(0)).to_not.exist()
        end)

        it("should return false if iKey is out of bounds (too high)", function()
            local success = xt:setByIKey(4, "attempt_fail")
            expect(success).to.be(false)
            expect(xt:getByIKey(4)).to_not.exist()
        end)

        it("should allow setting value to nil", function()
            local success = xt:setByIKey(3, nil)
            expect(success).to.be(true)
            expect(xt:getByIKey(3)).to_not.exist() -- Value is nil
            expect(xt:getNKeyByIKey(3)).to.be(true) -- nKey still exists
        end)
    end)

    describe("xtable:setByNKey()", function()
        it("should update the value for the specified nKey and return true", function()
            local success = xt:setByNKey("nKeyA", "valueA_updated_by_nKey")
            expect(success).to.be(true)

            local val, _, iKey = xt:getByNKey("nKeyA")
            expect(val).to.equal("valueA_updated_by_nKey")
            expect(iKey).to.equal(1) -- iKey should remain unchanged

            -- Verify other elements are unaffected
            expect(xt:getByNKey(123)).to.equal("valueB_initial")
            expect(xt:getByIKey(3)).to.equal("valueC_initial")
            expect(#xt).to.equal(3) -- Length should remain unchanged
        end)

        it("should not change the iKey associated with the nKey", function()
            local original_iKey = xt:getIKeyByNKey(123)
            xt:setByNKey(123, "valueB_updated_again")
            expect(xt:getIKeyByNKey(123)).to.equal(original_iKey)
        end)

        it("should return false if nKey does not exist", function()
            local success = xt:setByNKey("non_existent_nKey", "attempt_fail")
            expect(success).to.be(false)
        end)

        it("should allow setting value to nil for an existing nKey", function()
            local success = xt:setByNKey(true, nil)
            expect(success).to.be(true)
            local val, _, iKey = xt:getByNKey(true)
            expect(val).to_not.exist() -- Value is nil
            expect(iKey).to.equal(3)   -- iKey still associated
        end)
    end)
end)

describe("xtable - Removal (removeByNKey, removeAllByNKeys)", function()
    local xt

    before(function()
        xt = xtable.new()
        xt:insert("alpha", "val_A") -- iKey 1
        xt:insert("beta",  "val_B") -- iKey 2
        xt:insert("gamma", "val_C") -- iKey 3
        xt:insert("delta", "val_D") -- iKey 4
        xt:insert("epsilon", "val_E") -- iKey 5
    end)

    describe("xtable:removeByNKey()", function()
        it("should remove an item by nKey and return its value", function()
            local removed_value = xt:removeByNKey("gamma")
            expect(removed_value).to.equal("val_C")
            expect(#xt).to.equal(4)
            expect(xt:getByNKey("gamma")).to_not.exist()
            expect(xt:getIKeyByNKey("gamma")).to_not.exist()
        end)

        it("should re-index subsequent items correctly after removal", function()
            xt:removeByNKey("beta") -- Removed item at original iKey 2

            -- Original: alpha (1), beta (2), gamma (3), delta (4), epsilon (5)
            -- After removing beta: alpha (1), gamma (2), delta (3), epsilon (4)

            expect(xt:getIKeyByNKey("alpha")).to.equal(1)
            expect(xt:getByNKey("alpha")).to.equal("val_A")

            expect(xt:getIKeyByNKey("gamma")).to.equal(2) -- Was iKey 3
            expect(xt:getByNKey("gamma")).to.equal("val_C")

            expect(xt:getIKeyByNKey("delta")).to.equal(3) -- Was iKey 4
            expect(xt:getByNKey("delta")).to.equal("val_D")

            expect(xt:getIKeyByNKey("epsilon")).to.equal(4) -- Was iKey 5
            expect(xt:getByNKey("epsilon")).to.equal("val_E")

            expect(xt:getNKeyByIKey(2)).to.equal("gamma")
            expect(xt:getNKeyByIKey(4)).to.equal("epsilon")
        end)

        it("should return nil if the nKey does not exist", function()
            local removed_value = xt:removeByNKey("non_existent")
            expect(removed_value).to_not.exist()
            expect(#xt).to.equal(5) -- Length should be unchanged
        end)

        it("should handle removing the first item", function()
            local removed_value = xt:removeByNKey("alpha")
            expect(removed_value).to.equal("val_A")
            expect(#xt).to.equal(4)
            expect(xt:getIKeyByNKey("beta")).to.equal(1) -- beta is now at iKey 1
            expect(xt:getByIKey(1)).to.equal("val_B")
        end)

        it("should handle removing the last item", function()
            local removed_value = xt:removeByNKey("epsilon")
            expect(removed_value).to.equal("val_E")
            expect(#xt).to.equal(4)
            expect(xt:getByIKey(4)).to.equal("val_D") -- delta is still at iKey 4
            expect(xt:getByIKey(5)).to_not.exist()
        end)

        it("should correctly handle removal when only one item exists", function()
            local single_xt = xtable.new()
            single_xt:insert("only", "the_one")
            local removed_value = single_xt:removeByNKey("only")
            expect(removed_value).to.equal("the_one")
            expect(single_xt:len()).to.equal(0)
            expect(single_xt:getByNKey("only")).to_not.exist()
        end)
    end)

    describe("xtable:removeAllByNKeys()", function()
        it("should remove multiple items specified in a list", function()
            local removed_map = xt:removeAllByNKeys({"beta", "delta"})
            expect(#xt).to.equal(3)

            expect(removed_map["beta"]).to.equal("val_B")
            expect(removed_map["delta"]).to.equal("val_D")
            expect(removed_map["alpha"]).to_not.exist() -- Should not be in removed map

            expect(xt:getByNKey("beta")).to_not.exist()
            expect(xt:getByNKey("delta")).to_not.exist()
        end)

        it("should re-index correctly after removing multiple items", function()
            xt:removeAllByNKeys({"alpha", "gamma", "epsilon"})
            -- Original: alpha(1), beta(2), gamma(3), delta(4), epsilon(5)
            -- Kept: beta, delta
            -- New order: beta (1), delta (2)

            expect(#xt).to.equal(2)
            expect(xt:getIKeyByNKey("beta")).to.equal(1)
            expect(xt:getByNKey("beta")).to.equal("val_B")

            expect(xt:getIKeyByNKey("delta")).to.equal(2)
            expect(xt:getByNKey("delta")).to.equal("val_D")

            expect(xt:getNKeyByIKey(1)).to.equal("beta")
            expect(xt:getNKeyByIKey(2)).to.equal("delta")
        end)

        it("should return an empty map and not change xtable if nKeys_list is nil or empty", function()
            local removed_map_nil = xt:removeAllByNKeys(nil)
            expect(removed_map_nil).to.equal({})
            expect(#xt).to.equal(5)

            local removed_map_empty = xt:removeAllByNKeys({})
            expect(removed_map_empty).to.equal({})
            expect(#xt).to.equal(5)
        end)

        it("should ignore non-existent nKeys in the list and remove only existing ones", function()
            local removed_map = xt:removeAllByNKeys({"gamma", "non_existent_1", "alpha", "non_existent_2"})
            expect(#xt).to.equal(3)
            expect(removed_map["gamma"]).to.equal("val_C")
            expect(removed_map["alpha"]).to.equal("val_A")
            expect(removed_map["non_existent_1"]).to_not.exist()

            expect(xt:getByNKey("gamma")).to_not.exist()
            expect(xt:getByNKey("alpha")).to_not.exist()
            expect(xt:getByNKey("beta")).to.exist() -- Should still be there
        end)

        it("should return an empty map if no specified nKeys exist in the xtable", function()
            local removed_map = xt:removeAllByNKeys({"zeta", "omega"})
            expect(removed_map).to.equal({})
            expect(#xt).to.equal(5)
        end)

        it("should correctly handle removing all items", function()
            local all_keys = {"alpha", "beta", "gamma", "delta", "epsilon"}
            local removed_map = xt:removeAllByNKeys(all_keys)
            expect(#xt).to.equal(0)
            expect(removed_map["alpha"]).to.equal("val_A")
            expect(removed_map["epsilon"]).to.equal("val_E")
            expect(next(xt:toMap())).to_not.exist() -- Check if map is empty
        end)
    end)
end)

describe("xtable - Utility Methods (trios, toMap, toList, clear, hasNKey, hasIKey)", function()
    local xt

    before(function()
        xt = xtable.new()
        -- Using a known order of insertion for predictable iKey assignments
        xt:insert(1, "apple_val")       -- iKey 1
        xt:insert("key_b", "banana_val")-- iKey 2
        xt:insert(true, "cherry_val")   -- iKey 3
    end)

    describe("xtable:trios()", function()
        it("should iterate over items yielding iKey, nKey, and value in iKey order", function()
            local collected_items = {}
            for iKey, nKey, value in xt:trios() do
                table.insert(collected_items, { i = iKey, n = nKey, v = value })
            end

            expect(#collected_items).to.equal(3)

            expect(collected_items[1].i).to.equal(1)
            expect(collected_items[1].n).to.equal(1)
            expect(collected_items[1].v).to.equal("apple_val")

            expect(collected_items[2].i).to.equal(2)
            expect(collected_items[2].n).to.equal("key_b")
            expect(collected_items[2].v).to.equal("banana_val")

            expect(collected_items[3].i).to.equal(3)
            expect(collected_items[3].n).to.be(true) -- Use 'be' for boolean
            expect(collected_items[3].v).to.equal("cherry_val")
        end)

        it("should not iterate if the xtable is empty", function()
            local empty_xt = xtable.new()
            local count = 0
            for _ in empty_xt:trios() do
                count = count + 1
            end
            expect(count).to.equal(0)
        end)
    end)

    describe("xtable:toMap()", function()
        it("should return a standard Lua table mapping nKeys to values", function()
            local map = xt:toMap()
            expect(map[1]).to.equal("apple_val")
            expect(map["key_b"]).to.equal("banana_val")
            expect(map[true]).to.equal("cherry_val")
            expect(map["non_existent"]).to_not.exist()

            local count = 0
            for _ in pairs(map) do count = count + 1 end
            expect(count).to.equal(3)
        end)

        it("should return an empty table if xtable is empty", function()
            local empty_xt = xtable.new()
            expect(empty_xt:toMap()).to.equal({})
        end)
    end)

    describe("xtable:toList()", function()
        it("should return a standard Lua list (array) of values in iKey order", function()
            local list = xt:toList()
            expect(#list).to.equal(3)
            expect(list[1]).to.equal("apple_val")
            expect(list[2]).to.equal("banana_val")
            expect(list[3]).to.equal("cherry_val")
        end)

        it("should return an empty table if xtable is empty", function()
            local empty_xt = xtable.new()
            expect(empty_xt:toList()).to.equal({})
        end)
    end)

    describe("xtable:clear()", function()
        it("should remove all items from the xtable", function()
            xt:clear()
            expect(#xt).to.equal(0)
            expect(xt:toMap()).to.equal({})
            expect(xt:toList()).to.equal({})

            local count = 0
            for _ in xt:trios() do count = count + 1 end
            expect(count).to.equal(0)
        end)

        it("should allow re-populating after clear", function()
            xt:clear()
            xt:insert("new_key", "new_value")
            expect(#xt).to.equal(1)
            expect(xt:getByNKey("new_key")).to.equal("new_value")
        end)
    end)

    describe("xtable:hasNKey()", function()
        it("should return true if an nKey exists", function()
            expect(xt:hasNKey("key_b")).to.be(true)
            expect(xt:hasNKey(1)).to.be(true)
        end)

        it("should return false if an nKey does not exist", function()
            expect(xt:hasNKey("non_existent_key")).to.be(false)
            expect(xt:hasNKey(false)).to.be(false) -- `false` was not inserted as nKey
        end)

        it("should return false after an nKey is removed", function()
            xt:removeByNKey("key_b")
            expect(xt:hasNKey("key_b")).to.be(false)
        end)
    end)

    describe("xtable:hasIKey()", function()
        it("should return true if an iKey exists (is a valid index)", function()
            expect(xt:hasIKey(1)).to.be(true)
            expect(xt:hasIKey(3)).to.be(true)
        end)

        it("should return false if an iKey is out of bounds (too low or not a number)", function()
            expect(xt:hasIKey(0)).to.be(false)
            expect(xt:hasIKey(-1)).to.be(false)
            expect(xt:hasIKey("not_a_number")).to.be(false)
        end)

        it("should return false if an iKey is out of bounds (too high)", function()
            expect(xt:hasIKey(4)).to.be(false)
            expect(xt:hasIKey(100)).to.be(false)
        end)

        it("should return false for an iKey that was valid before a removal made it out of bounds", function()
            expect(xt:hasIKey(3)).to.be(true)
            xt:removeByNKey(true) -- Removes item at iKey 3
            expect(xt:hasIKey(3)).to.be(false) -- Now iKey 3 is out of bounds
        end)
    end)

end)

describe("xtable - Static Utility Methods", function()

    describe("xtable.isXTable()", function()
        it("should return true for an object created by xtable.new()", function()
            local xt = xtable.new()
            expect(xtable.isXTable(xt)).to.be(true)
        end)

        it("should return true for an object created by xtable.fromUPairs()", function()
            local data = { a = 1 }
            local xt = xtable.fromUPairs(data)
            expect(xtable.isXTable(xt)).to.be(true)
        end)

        it("should return true for an object created by xtable.fromOPairs()", function()
            local data = { b = 2 }
            local xt = xtable.fromOPairs(data)
            expect(xtable.isXTable(xt)).to.be(true)
        end)

        it("should return false for a standard Lua table", function()
            local tbl = {}
            expect(xtable.isXTable(tbl)).to.be(false)
        end)

        it("should return false for a table with a different metatable", function()
            local other_mt = { __index = {} }
            local tbl = setmetatable({}, other_mt)
            expect(xtable.isXTable(tbl)).to.be(false)
        end)

        it("should return false for nil", function()
            expect(xtable.isXTable(nil)).to.be(false)
        end)

        it("should return false for a number", function()
            expect(xtable.isXTable(123)).to.be(false)
        end)

        it("should return false for a string", function()
            expect(xtable.isXTable("hello")).to.be(false)
        end)

        it("should return false for a boolean", function()
            expect(xtable.isXTable(true)).to.be(false)
        end)

        it("should return false for a function", function()
            local func = function() end
            expect(xtable.isXTable(func)).to.be(false)
        end)

        it("should return false for the xtable module itself (the constructor table)", function()
            -- This tests that it's checking for an *instance*, not the class/module table.
            expect(xtable.isXTable(xtable)).to.be(false)
        end)
    end)
end)
