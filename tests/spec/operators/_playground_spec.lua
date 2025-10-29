local chain = require("chain")

describe("playground", function()

    it("test1", function()
        local data = {a = 10, c = 30, b = 20}
        local s = chain(data) -- wrapping the collection
                :filter(function(v) return v > 15 end) -- applying chainable operation(s)
                :map(function(v) return v * 2 end) -- each operation produces new `chain` instance
        -- etc...
        local result = s:toMap() -- unwrapping chain back into a table
        assert(type(result) == "table") -- it's a table

        print(result["a"], result["b"], result["c"])
    end)

    it("test2", function()
        local data = {a = 10, b = 20, c = 30}
        local s = chain(data) -- ordering for elements is not guaranteed, since collection is a `Map`
        s = s:order()     -- applying natural ordering by keys, note the re-assignment - because of the immutability

        print(( s:get("a") )) -- > "10" -- double-parenthesis to only print the first value (see below)
        print(( s:at(2)    )) -- > "20" -- guaranteed result, even for wrapped `Map`
        print(( s:val(30)  )) -- > "30" -- reverse lookup explained below
    end)

    --[[it("test3", function()
        local chain = require("chain")

        local s = chain({a = 10, b = 20, c = 30}):orderByKey() -- todo! implement

        local function printTrio(v, nk, ik)
            print("Value " .. v .. ", by key '" .. nk .. "', at position " .. ik)
        end

        local v, nk, ik = s:get("a")
        printTrio(v, nk, ik) -- > "Value 10, by key 'a', at position 1"

        v, nk, ik = s:at(2)
        printTrio(v, nk, ik) -- > "Value 20, by key 'b', at position 2"

        v, nk, ik = s:val(30)
        printTrio(v, nk, ik) -- > "Value 30, by key 'c', at position 3"
    end)]]

    it("test4", function()
        -- local result = chain({10, 20, 30, 40, 50}):slice(nil, nil, -2)

        chain({10, 20, 30, 40, 50})
                :slice(2, 4)
                :values():assertEquals({20, 30, 40})

        -- for ik, nk, v in result:trios() do
        --     print(ik, nk, v)
        -- end
    end)

    --[[it("test5", function()
        print(chain({10, 20, 30, 40, 50}):mkString(", ", function(v, k) return k .. "=" .. v end))
    end)]]

    it("test6", function()

        local printChain = function(ch)
            print("{ " .. ch:mkString(", ", function(v, k)
                return tostring(k) .. "=" .. tostring(v)
            end) .. " }")
        end

        chain({b = 20, c = 30, a = 10})
            :order()
            :assertEquals({a = 10, b = 20, c = 30})
            :encapsule()
            :assertEquals({ {a = 10}, {b = 20}, {c = 30} })

    end)

    it("test7", function()

--[[
        local serpent = require("serpent")
        local a = {1, nil, 3, x=1, ['true'] = 2, [not true]=3}
        a[a] = a -- self-reference with a table as key and value

        print("serpent.dump(a)") -- full serialization
        print(serpent.dump(a)) -- full serialization
        print("serpent.line(a)") -- single line, no self-ref section
        print(serpent.line(a)) -- single line, no self-ref section
        print("serpent.block(a)") -- multi-line indented, no self-ref section
        print(serpent.block(a)) -- multi-line indented, no self-ref section

        local fun, err = load(serpent.dump(a))
        if err then error(err) end
        local copy = fun()

        -- or using serpent.load:
        local ok, copy = serpent.load(serpent.dump(a))
        print("ok and copy[3] == a[3]")
        print(ok and copy[3] == a[3])

        local serpentSort = function(k, o, n)
            -- k=keys, o=originaltable, n=padding
            local maxn, to = tonumber(n) or 12, { number = 'a', string = 'b' }
            local function padnum(d)
                return ("%0" .. tostring(maxn) .. "d"):format(tonumber(d))
            end
            table.sort(k, function(a, b)
                -- sort numeric keys first: k[key] is not nil for numerical keys
                return (k[a] ~= nil and 0 or to[type(a)] or 'z') .. (tostring(a):gsub("%d+", padnum))
                        < (k[b] ~= nil and 0 or to[type(b)] or 'z') .. (tostring(b):gsub("%d+", padnum))
            end)
        end
]]



    end)
end)
