local chain = require("chain")

describe("Chain:singleOrError()", function()

    it("should return the single element when the chain has exactly one element", function()
        local data = {42}
        local result = chain(data):singleOrError()
        expect(result).to.equal(42)
    end)

    it("should raise an error for an empty chain with the default message", function()
        local data = {}
        local ok, err = pcall(function()
            chain(data):singleOrError()
        end)
        assert(not ok, "Expected an error for an empty chain.")
        assert(err:match("singleOrError failed: Expected single element."),
                "Expected the default error message for an empty chain.")
        assert(err:match("%(Found 0 elements%)"), "Expected the error to mention 0 elements.")
    end)

    it("should raise an error for a chain with multiple elements using the default message", function()
        local data = {1, 2}
        local ok, err = pcall(function()
            chain(data):singleOrError()
        end)
        assert(not ok, "Expected an error for multiple elements.")
        assert(err:match("singleOrError failed: Expected single element."),
                "Expected the default error message for multiple elements.")
        assert(err:match("%(Found 2 elements%)"), "Expected the error to mention 2 elements.")
    end)

    it("should raise a custom error message for an empty chain", function()
        local data = {}
        local customMessage = "Custom error for no elements"
        local ok, err = pcall(function()
            chain(data):singleOrError(customMessage)
        end)
        assert(not ok, "Expected an error for an empty chain.")
        assert(err:match(customMessage), "Expected the custom error message.")
        assert(err:match("%(Found 0 elements%)"), "Expected the error to mention 0 elements.")
    end)

    it("should raise a custom error message for multiple elements", function()
        local data = {10, 20, 30}
        local customMessage = "Only one element allowed"
        local ok, err = pcall(function()
            chain(data):singleOrError(customMessage)
        end)
        assert(not ok, "Expected an error for multiple elements.")
        assert(err:match(customMessage), "Expected the custom error message.")
        assert(err:match("%(Found 3 elements%)"), "Expected the error to mention 3 elements.")
    end)
end)
