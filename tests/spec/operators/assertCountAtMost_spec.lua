local chain = require("chain")

describe("Chain:assertCountAtMost()", function()

    it("should not raise an error if the chain has exactly the maximum allowed elements", function()
        local s = chain({10, 20})
        local noError = pcall(function() s:assertCountAtMost(2, "expected at most 2") end)
        assert(noError, "Expected no error when the chain has exactly the maximum allowed number of elements.")
    end)

    it("should not raise an error if the chain has fewer than the maximum allowed elements", function()
        local s = chain({42})
        local noError = pcall(function() s:assertCountAtMost(2, "expected at most 2") end)
        assert(noError, "Expected no error when the chain has fewer than the maximum allowed number of elements.")
    end)

    it("should raise an error if the chain has more than the maximum allowed elements", function()
        local s = chain({1, 2, 3})
        local ok, err = pcall(function() s:assertCountAtMost(2, "exceeded max") end)
        assert(not ok, "Expected an error when the chain exceeds the maximum allowed number of elements.")
        assert(err:match("exceeded max"), "Expected the custom error message for exceeding the max number of elements.")
        assert(err:match("%(Found 3 elements%)."), "Expected the error message to include the count of elements.")
    end)

    it("should use the default error message if none is provided", function()
        local s = chain({1, 2, 3, 4})
        local ok, err = pcall(function() s:assertCountAtMost(3) end)
        assert(not ok, "Expected an error when the chain has more elements than the maximum allowed with no custom message.")
        assert(err:match("Chain:assertCountAtMost failed: Expected count of at most 3."),
                "Expected the default error message.")
        assert(err:match("%(Found 4 elements%)."), "Expected the error message to include the count of elements.")
    end)

    it("should return the same chain instance on success", function()
        local s = chain({1, 2})
        local result = s:assertCountAtMost(2)
        assert(s == result, "Expected method to return the same chain instance on success.")
    end)
end)
