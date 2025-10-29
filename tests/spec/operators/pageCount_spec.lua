local chain = require("chain")

describe("Chain:pageCount()", function()

    it("should calculate correct page count for exact division", function()
        expect(
            chain({1, 2, 3, 4, 5, 6}):pageCount(2)
        ).to.equal(3) -- 6 items with 2 per page = 3 pages
    end)

    it("should round up when items don't divide evenly", function()
        local data = {1, 2, 3, 4, 5}
        local result = chain(data):pageCount(2)
        expect(result).to.equal(3) -- 5 items with 2 per page = 3 pages (last page has 1 item)
    end)

    it("should return 1 when itemsPerPage >= total items", function()
        local data = {1, 2, 3, 4, 5}
        local result = chain(data):pageCount(5)
        expect(result).to.equal(1) -- 5 items with 5 per page = 1 page

        result = chain(data):pageCount(10)
        expect(result).to.equal(1) -- 5 items with 10 per page = 1 page
    end)

    it("should return 0 for empty collection", function()
        local data = {}
        local result = chain(data):pageCount(5)
        expect(result).to.equal(0)
    end)

    it("should return 0 when itemsPerPage is 0", function()
        local data = {1, 2, 3, 4, 5}
        local result = chain(data):pageCount(0)
        expect(result).to.equal(0)
    end)

    it("should return 0 when itemsPerPage is negative", function()
        local data = {1, 2, 3, 4, 5}
        local result = chain(data):pageCount(-3)
        expect(result).to.equal(0)
    end)

    it("should throw error when itemsPerPage is not a number", function()
        local data = {1, 2, 3, 4, 5}
        expect(function()
            chain(data):pageCount("2")
        end).to.fail("pageCount(itemsPerPage): itemsPerPage must be an integer (got string: '2')")

        expect(function()
            chain(data):pageCount(nil)
        end).to.fail("pageCount(itemsPerPage): itemsPerPage must be an integer (got nil)")

        expect(function()
            chain(data):pageCount({})
        end).to.fail("pageCount(itemsPerPage): itemsPerPage must be an integer (got table)")
    end)

    it("should throw error when itemsPerPage is not an integer", function()
        local data = { 1, 2, 3, 4, 5 }
        expect(function()
            chain(data):pageCount(2.5)
        end).to.fail("pageCount(itemsPerPage): itemsPerPage must be an integer (got a non-integer number: 2.5)")
    end)

    it("should work with large collections", function()
        local data = {}
        for i = 1, 100 do
            table.insert(data, i)
        end

        local result = chain(data):pageCount(10)
        expect(result).to.equal(10) -- 100 items with 10 per page = 10 pages

        result = chain(data):pageCount(3)
        expect(result).to.equal(34) -- 100 items with 3 per page = 33.33... = 34 pages
    end)

    it("should work with tables used as maps", function()
        local data = {a = 1, b = 2, c = 3, d = 4, e = 5}
        local result = chain(data):pageCount(2)
        expect(result).to.equal(3)
    end)

    it("should accept integer-like float values", function()
        local data = {1, 2, 3, 4, 5, 6, 7, 8}
        local result = chain(data):pageCount(3.0)
        expect(result).to.equal(3)
    end)
end)
