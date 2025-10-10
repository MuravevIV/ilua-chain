local Chain = require("chain_class")

-- todo! docs and tests
function Chain:decapsule()
    return Chain.new(self._xt:map(function(v)
        if type(v) == "table" then
            local first, single, ck1, cv1 = true, true, nil, nil
            for ck, cv in pairs(v) do
                if first then
                    first, ck1, cv1 = false, ck, cv
                else
                    single = false
                    break
                end
            end
            if single then
                return cv1, ck1
            end
        end
    end))
end
