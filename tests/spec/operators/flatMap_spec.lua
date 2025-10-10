local chain = require("chain")

describe("Chain:flatMap()", function()

    it("should map elements to tables and flatten the results", function()
        chain({1, 2, 3})
            :flatMap(function(v) return {v, v * 10} end)
            :assertEquals({1, 10, 2, 20, 3, 30})
    end)

    it("should map elements to chains and flatten the results", function()
        chain({1, 2, 3})
            :flatMap(function(v) return chain({v, v * 10}) end)
            :assertEquals({1, 10, 2, 20, 3, 30})
    end)

    it("should pass key to the mapper function", function()
        chain({a = 10, b = 20})
            :flatMap(function(v, k) return {k, v} end)
            :assertEquals({"a", 10, "b", 20})
    end)

    it("should pass index to the mapper function", function()
        chain({a = 10, b = 20})
            :flatMap(function(v, k, idx) return {idx, k, v} end)
            :assertEquals({1, "a", 10, 2, "b", 20})
    end)

    it("should remap keys when provided with keyMapper and mapper uses s table", function()
        chain({a = 10, b = 20})
            :flatMap(
                function(v, k, idx)
                    return {idx, k, v}
                end,
                function(pv, pk, pi, cv, ck, ci)
                    return pi .. "-" .. pk .. "-" .. pv .. " / " .. ci .. "-" .. ck .. "-" .. cv
                end
            )
            :assertEquals({
                ["1-a-10 / 1-1-1"]  = 1,
                ["1-a-10 / 2-2-a"]  = "a",
                ["1-a-10 / 3-3-10"] = 10,
                ["2-b-20 / 4-1-2"]  = 2,
                ["2-b-20 / 5-2-b"]  = "b",
                ["2-b-20 / 6-3-20"] = 20
            })
    end)

    it("should remap keys when provided with keyMapper and mapper uses s chain", function()
        chain({pa = 10, pb = 20})
            :flatMap(
                function(v, k, idx)
                    return chain({ {ca = idx}, {cb = k}, {cc = v} })
                        :decapsule() -- enforcing order
                        :assertEquals({ca = idx, cb = k, cc = v})
                end,
                function(pv, pk, pi, cv, ck, ci)
                    return pi .. "-" .. pk .. "-" .. pv .. " / " .. ci .. "-" .. ck .. "-" .. cv
                end
            )
            :assertEquals({
                ["1-pa-10 / 1-ca-1"]  = 1,
                ["1-pa-10 / 2-cb-pa"] = "pa",
                ["1-pa-10 / 3-cc-10"] = 10,
                ["2-pb-20 / 4-ca-2"]  = 2,
                ["2-pb-20 / 5-cb-pb"] = "pb",
                ["2-pb-20 / 6-cc-20"] = 20
            })
    end)

    it("should return an empty chain if the input chain is empty", function()
        chain({})
            :flatMap(function(v) return {v, v .. "!"} end)
            :assertEquals({})
    end)

    it("should ignore nil results from the mapper function", function()
        chain({1, 2, 3})
            :flatMap(function(v)
                if v % 2 == 0 then
                    return {v, v * 10}
                else
                    return nil
                end
            end)
            :assertEquals({2, 20})
    end)

    it("should flatten nested tables into a single-level result", function()
        chain({"x", "y"})
            :flatMap(function(v) return {v, {v .. "1", v .. "2"}} end)
            :assertEquals({"x", {"x1", "x2"}, "y", {"y1", "y2"}})
    end)

    it("should handle empty tables from mapper function", function()
        chain({1, 2, 3})
            :flatMap(function(v)
                if v % 2 == 0 then
                    return {v}
                else
                    return {}
                end
            end)
            :assertEquals({2})
    end)

    it("should allow transformation to different types", function()
        chain({1, 2})
            :flatMap(function(v)
                return {"num" .. v, v}
            end)
            :assertEquals({"num1", 1, "num2", 2})
    end)

    it("should preserve the ordering of input elements while flattening", function()
        chain({"c", "a", "b"})
            :flatMap(function(v)
                return {v .. "1", v .. "2"}
            end)
            :assertEquals({"c1", "c2", "a1", "a2", "b1", "b2"})
    end)

    it("should maintain stability when elements have different output sizes", function()
        chain({3, 1, 2})
            :flatMap(function(value)
                local output = {}
                for _ = 1, value do
                    table.insert(output, value)
                end
                return output
            end)
            :assertEquals({3, 3, 3, 1, 2, 2})
    end)

    it("should throw an error when mapper is not a function", function()
        expect(function()
            chain({}):flatMap("not a function")
        end).to.fail("flatMap(mapper, keyMapper): mapper must be a function (got string: 'not a function')")
    end)

    it("should throw an error when mapper is nil", function()
        expect(function()
            chain({}):flatMap()
        end).to.fail(" flatMap(mapper, keyMapper): mapper must be a function (got nil)")
    end)
end)
