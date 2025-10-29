
local chain = require("chain")

describe("Chain:mergeByKeyInto()", function()

    it("merges overriding existing keys with current values", function()
        local target = {
            a = {x = 1},
            b = {y = 2},
            c = {z = 3}
        }
        local currentData = {
            b = {y = 20},
            d = {w = 4}
        }

        local result = chain(currentData):mergeByKeyInto(target):toMap()

        expect(result.a.x).to.equal(1)
        expect(result.b.y).to.equal(20)
        expect(result.c.z).to.equal(3)
        expect(result.d.w).to.equal(4)

        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(4)

        expect(target.b.y).to.equal(2)
    end)

    it("adds new keys when no overlap", function()
        local target = {
            a = {x = 1}
        }
        local currentData = {
            b = {y = 2}
        }

        local result = chain(currentData):mergeByKeyInto(target):toMap()

        expect(result.a.x).to.equal(1)
        expect(result.b.y).to.equal(2)

        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(2)
    end)

    it("returns copy of target when current is empty", function()
        local target = {
            a = {x = 1},
            b = {y = 2}
        }
        local currentData = {}

        local result = chain(currentData):mergeByKeyInto(target):toMap()

        expect(result.a.x).to.equal(1)
        expect(result.b.y).to.equal(2)

        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(2)
    end)

    it("returns empty when target empty and current empty", function()
        local target = {}
        local currentData = {}

        local result = chain(currentData):mergeByKeyInto(target):toMap()

        expect(result).to.equal({})
    end)

    it("merges with string keys as in hero example", function()
        local heroes = {
            Harry   = { age = 32, sex = "m" },
            Henry   = { age = 28, sex = "m" },
            James   = { age = 29, sex = "m" },
            Heather = { age = 17, sex = "f" }
        }

        local modified = {
            Henry   = { age = 28, sex = "m", status = "Chosen" }
        }

        local result = chain(modified):mergeByKeyInto(heroes):toMap()

        expect(result.Harry.age).to.equal(32)
        expect(result.Henry.age).to.equal(28)
        expect(result.Henry.status).to.equal("Chosen")
        expect(result.James.age).to.equal(29)
        expect(result.Heather.age).to.equal(17)

        local count = 0
        for _ in pairs(result) do
            count = count + 1
        end
        expect(count).to.equal(4)

        expect(heroes.Henry.status).to.equal(nil)
    end)
end)
