
local chain = require("chain")

describe("Chain:assertMultiple()", function()

    it("should not raise an error if the chain has more than one element", function()
        local s = chain({42, 43})
        local noError = pcall(function() s:assertMultiple("multiple elements") end)
        expect(noError).to.equal(true)
        expect(s).to.equal(s:assertMultiple())
    end)

    it("should raise an error if the chain has zero elements", function()
        local s = chain({})
        expect(function()
            s:assertMultiple("zero elements")
        end).to.fail("zero elements (Found 0 elements).")
    end)

    it("should raise an error if the chain has exactly one element", function()
        local s = chain({1})
        expect(function()
            s:assertMultiple("one element")
        end).to.fail("one element (Found 1 elements).")
    end)

    it("should use the default error message if none is provided", function()
        local s = chain({1})
        expect(function()
            s:assertMultiple()
        end).to.fail("Chain:assertMultiple failed: Expected more than one element. (Found 1 elements).")
    end)
end)
