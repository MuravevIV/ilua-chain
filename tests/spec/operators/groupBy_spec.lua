local chain = require("chain")

describe("Chain:groupBy", function()

    it("throws an error when keyExtractor is not a function", function()
        expect(function()
            chain({}):groupBy("not a function")
        end).to.fail("groupBy(keyExtractor): keyExtractor must be a function (got string: 'not a function')")
    end)

    it("returns an empty chain when the original collection is empty", function()
        chain({})
            :groupBy(function(v) return v.type end)
            :assertEquals({})
    end)

    it("skips elements when keyExtractor returns nil", function()
        local data = {
            { type = "admin", name = "Alice"               },
            { type = nil,     name = "ShouldBeSkipped"     },
            {                 name = "ShouldAlsoBeSkipped" },
            { type = "admin", name = "Bob"                 }
        }
        chain(data)
            :groupBy(function(v) return v.type end)
            :assertEquals({
                admin = chain({
                    [1] = { type = "admin", name = "Alice" },
                    [4] = { type = "admin", name = "Bob"   }
                })
            })
    end)

    it("groups elements correctly when keyExtractor is valid", function()
        local data = {
            {type = "admin", name = "Alice"},
            {type = "user",  name = "Bob"},
            {type = "admin", name = "Charlie"},
            {type = "guest", name = "Derek"}
        }
        chain(data)
            :groupBy(function(v) return v.type end)
            :assertEquals({
                admin = chain({
                    {type = "admin", name = "Alice"},
                    {type = "admin", name = "Charlie"}
                }),
                user = chain({
                    {type = "user", name = "Bob"}
                }),
                guest = chain({
                    {type = "guest", name = "Derek"}
                })
            })
    end)

    it("should group elements correctly when passed key", function()
        local data = {
            a = {type = "admin", name = "Alice"},
            b = {type = "user",  name = "Bob"},
            c = {type = "admin", name = "Charlie"},
            d = {type = "guest", name = "Derek"}
        }
        chain(data)
            :groupBy(function(v, k) return v.type .. "_" .. k end)
            :assertEquals({
                admin_a = chain({
                    {type = "admin", name = "Alice"}
                }),
                user_b = chain({
                    {type = "user", name = "Bob"}
                }),
                admin_c = chain({
                    {type = "admin", name = "Charlie"}
                }),
                guest_d = chain({
                    {type = "guest", name = "Derek"}
                })
            })
    end)

    it("should group elements correctly when passed key and index", function()
        local data = {
            a = {type = "admin", name = "Alice"},
            b = {type = "user",  name = "Bob"},
            c = {type = "admin", name = "Charlie"},
            d = {type = "guest", name = "Derek"}
        }
        chain(data)
            :groupBy(function(v, k, i) return v.type .. "_" .. k .. "_" .. i end)
            :assertEquals({
                admin_a_1 =chain({
                    {type = "admin", name = "Alice"}
                }),
                user_b_2 = chain({
                    {type = "user", name = "Bob"}
                }),
                admin_c_3 = chain({
                    {type = "admin", name = "Charlie"}
                }),
                guest_d_4 = chain({
                    {type = "guest", name = "Derek"}
                })
            })
    end)
end)
