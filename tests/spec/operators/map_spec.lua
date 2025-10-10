local chain = require("chain")

describe("Chain:map()", function()

    it("should transform each List element using the mapper function", function()
        chain({ 10, 20, 30 })
            :map(function(v, k, i) return i .. "/" .. k .. "/" .. v end)
            :assertEquals({ "1/1/10", "2/2/20", "3/3/30" })
    end)

    it("should transform each Dict element using the mapper function", function()
        chain({ a = 10, b = 20, c = 30 })
            :map(function(v, k, i) return i .. "/" .. k .. "/" .. v end)
            :assertEquals({ a = "1/a/10", b = "2/b/20", c = "3/c/30" })
    end)

    it("should be able to map keys together with values when keys are provided by the mapper", function()
        chain({ a = 10, b = 20, c = 30 })
            :map(function(v, k) return v .. "_new", k .. "_new" end)
            :assertEquals({ a_new = "10_new", b_new = "20_new", c_new = "30_new" })
    end)

    it("should be able to map values correctly when keys are not provided by the mapper", function()
        chain({ a = 10, b = 20, c = 30 })
            :map(function(v) return v .. "_new", nil end)
            :assertEquals({ a = "10_new", b = "20_new", c = "30_new" })
    end)

    it("should be able to map values correctly when only some keys are not provided by the mapper", function()
        chain({ a = 10, b = 20, c = 30 })
            :map(function(v, k)
                if k == "b" then
                    return v .. "_new", nil
                else
                    return v .. "_new", k .. "_new"
                end
            end)
            :assertEquals({ a_new = "10_new", b = "20_new", c_new = "30_new" })
    end)

    it("should ignore keys provided by the mapper when they are accompanied with nil values", function()
        chain({ a = 10, b = 20, c = 30 })
            :map(function(_, k) return nil, k .. "_new" end)
            :assertEquals({})
    end)

    it("should return an empty chain if the input chain is empty", function()
        chain({})
            :map(function(v) return v .. "!" end)
            :assertEquals({})
    end)

    it("should preserve the original element order", function()
        chain({ 3, 1, 2 })
            :map(function(v) return v * 2 end)
            :assertEquals({ 6, 2, 4 })
    end)

    it("should throw an error when mapper is not a function", function()
        expect(function()
            chain({}):map()
        end).to.fail("map(mapper): mapper must be a function (got nil)")
        expect(function()
            chain({}):map("not_a_function")
        end).to.fail("map(mapper): mapper must be a function (got string: 'not_a_function')")
    end)
end)
