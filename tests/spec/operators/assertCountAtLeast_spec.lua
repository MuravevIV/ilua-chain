local chain = require("chain")

describe("Chain:assertCountAtLeast()", function()

    it("should not raise an error if the chain has exactly the minimum required elements", function()
        local s = chain({10, 20})
        local noError = pcall(function() s:assertCountAtLeast(2, "expected at least 2 elements") end)
        assert(noError, "Expected no error when the chain has exactly the required minimum of elements.")
    end)

    it("should not raise an error if the chain has more than the minimum required elements", function()
        local s = chain({1, 2, 3})
        local noError = pcall(function() s:assertCountAtLeast(2, "expected at least 2 elements") end)
        assert(noError, "Expected no error when the chain exceeds the required minimum number of elements.")
    end)

    it("should raise an error if the chain has fewer than the required elements", function()
        local s = chain({42})
        local ok, err = pcall(function() s:assertCountAtLeast(2, "need at least 2") end)
        assert(not ok, "Expected an error when the chain does not meet the required minimum count.")
        assert(err:match("need at least 2"), "Expected the custom error message for insufficient elements.")
        assert(err:match("%(Found 1 elements%)."), "Expected the reported element count in the error message.")
    end)

    it("should use the default error message if none is provided", function()
        local s = chain({})
        local ok, err = pcall(function() s:assertCountAtLeast(1) end)
        assert(not ok, "Expected an error when the chain has fewer elements than required and no custom message is given.")
        assert(err:match("Chain:assertCountAtLeast failed: Expected count of at least 1."),
                "Expected the default error message to be used.")
        assert(err:match("%(Found 0 elements%)."), "Expected the reported element count in the default message.")
    end)

    it("should return the same chain instance on success", function()
        local s = chain({1, 2})
        local result = s:assertCountAtLeast(2)
        assert(s == result, "Expected method to return the same chain instance on success.")
    end)
end)
