
local chain = require("chain")

describe("Chain:proxyUserdata()", function()

    it("returns unchanged for non-userdata values", function()
        local func = function() end
        local data = {1, "string", true, func}

        local result = chain(data):proxyUserdata():toList()

        expect(result).to.equal({1, "string", true, func})
    end)

    it("returns new Chain with new map for map input", function()
        local data = {a = 1, b = "two"}

        local result = chain(data):proxyUserdata():toMap()

        expect(result.a).to.equal(1)
        expect(result.b).to.equal("two")
    end)

    it("returns empty for empty chain", function()
        local data = {}

        local result = chain(data):proxyUserdata():toList()

        expect(result).to.equal({})
    end)

    it("does not modify original chain", function()
        local data = {a = 1}

        local original = chain(data)
        original:proxyUserdata()

        expect(original:toMap().a).to.equal(1)
    end)

    -- The following tests require an environment with userdata (e.g., via Lua extensions like Sol).
    -- They are commented out as pure Lua cannot create userdata for testing.

    -- it("wraps userdata allowing new field assignment", function()
    --     -- Assume 'ud' is a userdata object from some extension, e.g., local ud = some_extension.create_userdata()
    --     local ud = assume_userdata({x = 10})  -- Placeholder for userdata with field x=10

    --     local data = {ud}

    --     local result = chain(data):proxyUserdata():toList()

    --     local wrapped = result[1]
    --     expect(wrapped.x).to.equal(10)  -- Reads from original

    --     wrapped.y = 20  -- Sets new field on proxy
    --     expect(wrapped.y).to.equal(20)
    --     expect(ud.y).to.equal(nil)  -- Original unchanged
    -- end)

    -- it("forwards __len to userdata", function()
    --     local ud = assume_userdata({1, 2, 3})  -- Userdata with length 3

    --     local data = {ud}

    --     local result = chain(data):proxyUserdata():toList()

    --     local wrapped = result[1]
    --     expect(#wrapped).to.equal(3)
    -- end)

    -- it("forwards __pairs to userdata", function()
    --     local ud = assume_userdata({a = 1, b = 2})

    --     local data = {ud}

    --     local result = chain(data):proxyUserdata():toList()

    --     local wrapped = result[1]
    --     local pairsResult = {}
    --     for k, v in pairs(wrapped) do
    --         pairsResult[k] = v
    --     end
    --     expect(pairsResult).to.equal({a = 1, b = 2})
    -- end)

    -- it("forwards __ipairs to userdata", function()
    --     local ud = assume_userdata({10, 20, 30})

    --     local data = {ud}

    --     local result = chain(data):proxyUserdata():toList()

    --     local wrapped = result[1]
    --     local ipairsResult = {}
    --     for i, v in ipairs(wrapped) do
    --         ipairsResult[i] = v
    --     end
    --     expect(ipairsResult).to.equal({10, 20, 30})
    -- end)

    -- it("forwards arithmetic metamethods", function()
    --     local ud1 = assume_userdata(5)
    --     local ud2 = assume_userdata(3)

    --     local data = {ud1, ud2}

    --     local result = chain(data):proxyUserdata():toList()

    --     local wrapped1 = result[1]
    --     local wrapped2 = result[2]

    --     expect(wrapped1 + wrapped2).to.equal(8)
    --     expect(wrapped1 - wrapped2).to.equal(2)
    --     expect(wrapped1 * wrapped2).to.equal(15)
    --     expect(wrapped1 / wrapped2).to.equal(5/3)
    --     expect(wrapped1 % wrapped2).to.equal(2)
    --     expect(wrapped1 ^ wrapped2).to.equal(125)
    --     expect(-wrapped1).to.equal(-5)
    -- end)

    -- it("forwards comparison metamethods", function()
    --     local ud1 = assume_userdata(5)
    --     local ud2 = assume_userdata(3)

    --     local data = {ud1, ud2}

    --     local result = chain(data):proxyUserdata():toList()

    --     local wrapped1 = result[1]
    --     local wrapped2 = result[2]

    --     expect(wrapped1 == wrapped1).to.equal(true)
    --     expect(wrapped1 ~= wrapped2).to.equal(true)
    --     expect(wrapped1 < wrapped2).to.equal(false)
    --     expect(wrapped1 <= wrapped2).to.equal(false)
    --     expect(wrapped1 > wrapped2).to.equal(true)
    --     expect(wrapped1 >= wrapped2).to.equal(true)
    -- end)

    -- it("forwards __call to userdata", function()
    --     local ud = assume_userdata(function(a, b) return a + b end)  -- Callable userdata

    --     local data = {ud}

    --     local result = chain(data):proxyUserdata():toList()

    --     local wrapped = result[1]
    --     expect(wrapped(4, 6)).to.equal(10)
    -- end)

    -- it("forwards __tostring to userdata", function()
    --     local ud = assume_userdata_with_tostring("test_ud")

    --     local data = {ud}

    --     local result = chain(data):proxyUserdata():toList()

    --     local wrapped = result[1]
    --     expect(tostring(wrapped)).to.equal("[WrappedUserdata: test_ud]")
    -- end)

    -- it("handles mixed userdata and non-userdata", function()
    --     local ud = assume_userdata({x = 10})
    --     local data = {ud, 42, "string"}

    --     local result = chain(data):proxyUserdata():toList()

    --     expect(type(result[1])).to.equal("table")  -- Wrapped
    --     expect(result[1].x).to.equal(10)
    --     expect(result[2]).to.equal(42)
    --     expect(result[3]).to.equal("string")
    -- end)
end)
