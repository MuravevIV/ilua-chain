local chain = require("chain")

describe("Chain:assertCountEquals()", function()

    it("should not raise an error if the chain has exactly N elements", function()
        local s = chain({10, 20, 30})
        local noError = pcall(function() s:assertCountEquals(3, "expected 3 elements") end)
        assert(noError, "Expected no error when the chain has exactly the specified number of elements.")
    end)

    it("should raise an error if the chain does not have the specified number of elements", function()
        local s = chain({42})
        local ok, err = pcall(function() s:assertCountEquals(2, "expected 2 elements") end)
        assert(not ok, "Expected an error when the chain does not have the specified count.")
        assert(err:match("expected 2 elements"), "Expected the custom error message for mismatched element count.")
        assert(err:match("%(Found 1 elements%)."), "Expected the reported element count in the error message.")
    end)

    it("should use the default error message if none is provided", function()
        local s = chain({1, 2, 3, 4})
        local ok, err = pcall(function() s:assertCountEquals(2) end)
        assert(not ok, "Expected an error when there are more elements than required and no custom message is given.")
        assert(err:match("Chain:assertCountEquals failed: Expected count of 2."),
                "Expected the default error message to be used.")
        assert(err:match("%(Found 4 elements%)."), "Expected the reported element count in the default message.")
    end)

    it("should return the same chain instance on success", function()
        local s = chain({1, 2})
        local result = s:assertCountEquals(2)
        assert(s == result, "Expected method to return the same chain instance on success.")
    end)
end)
