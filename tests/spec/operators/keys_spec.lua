local chain = require("chain")

describe("Chain:keys()", function()

    it("should return all keys from a table used as a map", function()
        chain({ a = 1, b = 2, c = 3 })
            :keys()
            :assertEquals({ "a", "b", "c" })
    end)

    it("should return numeric indices from an array", function()
        chain({ "apple", "banana", "cherry" })
            :keys()
            :assertEquals({ 1, 2, 3 })
    end)

    it("should return both numeric and string keys from mixed tables", function()
        chain({ 10, 20, a = "apple", b = "banana" })
            :keys()
            :assertEquals({ 1, 2, "a", "b" })
    end)

    it("should return an empty chain for an empty table", function()
        chain({})
            :keys()
            :assertEquals({})
    end)

    it("should work with nested tables", function()
        local data = {
            settings = {
                darkMode = true,
                notifications = false
            },
            users = {
                { name = "Alice", age = 30 },
                { name = "Bob", age = 25 }
            }
        }
        chain(data)
            :keys()
            :assertEquals({ "settings", "users" })
    end)

    it("should work with tables containing nil values", function()
        chain({ a = 1, b = nil, c = 3 })
            :keys()
            :assertEquals({ "a", "c" })
    end)

    it("should work with complex key types - todo remove", function() -- todo! remove
        local complexKey1 = {id = 1}
        local complexKey2 = {id = 2}
        local metatable = {__index = function() return "fallback" end}

        local data = {}
        data[complexKey1] = "value1"
        data[complexKey2] = "value2"
        setmetatable(data, metatable)

        local result = chain(data):keys():toList()
        expect(#result).to.equal(2)

        -- Check that the keys in result are the same complex keys
        local foundKey1 = false
        local foundKey2 = false

        for _, k in ipairs(result) do
            if k.id == 1 then foundKey1 = true end
            if k.id == 2 then foundKey2 = true end
        end

        expect(foundKey1).to.equal(true)
        expect(foundKey2).to.equal(true)
    end)

    -- todo! fix it
    --[[it("should work with complex key types", function()
        local complexKey1 = {id = 1, m = 3}
        local complexKey2 = {id = 2, m = 5}

        local data = {}
        data[complexKey1] = "value1"
        data[complexKey2] = "value2"

        local what = chain(data):keys()

        chain(data):keys():assertEquals({ complexKey1, complexKey2 })
    end)]]
end)
