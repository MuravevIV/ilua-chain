local chain = require("chain")

describe("Chain:assertIsNotEmpty()", function()

    it("should not raise an error if the chain is not empty", function()
        local s = chain({42})
        local noError = pcall(function() s:assertIsNotEmpty("non-empty chain") end)
        assert(noError, "Expected no error when the chain has elements.")
    end)

    it("should raise an error if the chain is empty", function()
        local s = chain({})
        local ok, err = pcall(function() s:assertIsNotEmpty("empty chain") end)
        assert(not ok, "Expected an error when the chain is empty.")
        assert(err:match("empty chain"), "Expected the custom error message for empty chains.")
    end)

    it("should use the default error message if none is provided", function()
        local s = chain({})
        local ok, err = pcall(function() s:assertIsNotEmpty() end)
        assert(not ok, "Expected an error when the chain is empty and no custom message is given.")
        assert(err:match("Chain:assertIsNotEmpty failed: The collection is empty."),
                "Expected the default error message to be used.")
    end)

    it("should return the same chain instance on success", function()
        local s = chain({1, 2, 3})
        local result = s:assertIsNotEmpty()
        assert(s == result, "Expected method to return the same chain instance.")
    end)
end)
