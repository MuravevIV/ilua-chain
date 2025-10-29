local chain = require("chain")

describe("Chain:assertIsEmpty()", function()

    it("should not raise an error if the chain is indeed empty", function()
        local s = chain({})
        local noError = pcall(function() s:assertIsEmpty("empty collection") end)
        assert(noError, "Expected no error when the chain is empty.")
    end)

    it("should raise an error if the chain is not empty", function()
        local s = chain({42})
        local ok, err = pcall(function() s:assertIsEmpty("not empty") end)
        assert(not ok, "Expected an error when the chain is not empty.")
        assert(err:match("not empty"), "Expected the custom error message for a non-empty collection.")
        assert(err:match("%(Found 1 elements%)"), "Should include the found elements count in the message.")
    end)

    it("should use the default error message if none is provided", function()
        local s = chain({1, 2})
        local ok, err = pcall(function() s:assertIsEmpty() end)
        assert(not ok, "Expected an error when the chain is not empty and no custom message is given.")
        assert(err:match("Chain:assertIsEmpty failed: The collection is not empty."),
                "Expected the default error message to be used.")
        assert(err:match("%(Found 2 elements%)"), "Should include the count of elements in the default message.")
    end)

    it("should return the same chain instance on success", function()
        local s = chain({})
        local result = s:assertIsEmpty()
        assert(s == result, "Expected method to return the same chain instance upon success.")
    end)
end)
