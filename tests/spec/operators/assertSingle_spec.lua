local chain = require("chain")

describe("Chain:assertSingle()", function()

    it("should not raise an error if the chain has exactly one element", function()
        local s = chain({42})
        local noError = pcall(function() s:assertSingle("one element") end)
        assert(noError, "Expected no error when there is exactly one element in the chain.")
        -- Also ensure it returns the same chain object
        assert(s == s:assertSingle(), "Expected method to return the same chain instance.")
    end)

    it("should raise an error if the chain has zero elements", function()
        local s = chain({})
        local ok, err = pcall(function() s:assertSingle("zero elements") end)
        assert(not ok, "Expected an error when there are zero elements in the chain.")
        assert(err:match("zero elements"), "Expected the custom error message for zero elements.")
        assert(err:match("%(Found 0 elements%)."), "Expected the reported element count in the error message.")
    end)

    it("should raise an error if the chain has more than one element", function()
        local s = chain({1, 2})
        local ok, err = pcall(function() s:assertSingle("multiple elements") end)
        assert(not ok, "Expected an error when there are multiple elements in the chain.")
        assert(err:match("multiple elements"), "Expected the custom error message for multiple elements.")
        assert(err:match("%(Found 2 elements%)."), "Expected the reported element count in the error message.")
    end)

    it("should use the default error message if none is provided", function()
        local s = chain({1, 2})
        local ok, err = pcall(function() s:assertSingle() end)
        assert(not ok, "Expected an error when there are multiple elements and no custom message.")
        assert(err:match("Chain:assertSingle failed: Expected exactly one element."),
                "Expected the default error message to be used.")
        assert(err:match("%(Found 2 elements%)."), "Expected the reported element count in the error message.")
    end)
end)
