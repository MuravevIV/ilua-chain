local chain = require("chain")

describe("chain.fromPairs()", function()

    it("should generate Dict chain from a List", function()
        chain.fromPairs({ "c", 30, "b", 20, "a", 10 })
            :assertEquals({ c = 30, b = 20, a = 10 })
            :keys():assertEquals({ "c", "b", "a" })
    end)

    it("should generate empty Dict chain from an empty List", function()
        chain.fromPairs({}):assertEquals({})
    end)

    it("should silently drop the dangling tail key from a List", function()
        chain.fromPairs({ "c", 30, "b", 20, "a" })
             :assertEquals({ c = 30, b = 20 })
             :keys():assertEquals({ "c", "b" })
    end)
end)
