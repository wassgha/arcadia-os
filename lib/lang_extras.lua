-- Table Operations
function table.add(t1, t2)
    -- Get the current length of t1, assuming it may have array elements
    local t1Length = #t1

    -- Append array-like elements from t2
    for i, v in ipairs(t2) do
        t1[t1Length + i] = v
    end

    -- Copy or override key-value pairs from t2 for dictionaries
    for k, v in pairs(t2) do
        if type(k) ~= "number" then
            t1[k] = v
        end
    end
end

function table.shallowCopy(t)
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = v
    end
    return t2
end

function table.omit(tbl, keys)
    local result = {}
    local keySet = {}

    -- Create a set of keys to omit for faster lookup
    for _, key in ipairs(keys) do
        keySet[key] = true
    end

    -- Copy only keys not in the keySet
    for k, v in pairs(tbl) do
        if not keySet[k] then
            result[k] = v
        end
    end

    return result
end

function table.deepEquals(table1, table2)
    local avoid_loops = {}
    local function recurse(t1, t2)
        -- compare value types
        if type(t1) ~= type(t2) then
            return false
        end
        -- Base case: compare simple values
        if type(t1) ~= "table" then
            return t1 == t2
        end
        -- Now, on to tables.
        -- First, let's avoid looping forever.
        if avoid_loops[t1] then
            return avoid_loops[t1] == t2
        end
        avoid_loops[t1] = t2
        -- Copy keys from t2
        local t2keys = {}
        local t2tablekeys = {}
        for k, _ in pairs(t2) do
            if type(k) == "table" then
                table.insert(t2tablekeys, k)
            end
            t2keys[k] = true
        end
        -- Let's iterate keys from t1
        for k1, v1 in pairs(t1) do
            local v2 = t2[k1]
            if type(k1) == "table" then
                -- if key is a table, we need to find an equivalent one.
                local ok = false
                for i, tk in ipairs(t2tablekeys) do
                    if table_eq(k1, tk) and recurse(v1, t2[tk]) then
                        table.remove(t2tablekeys, i)
                        t2keys[tk] = nil
                        ok = true
                        break
                    end
                end
                if not ok then
                    return false
                end
            else
                -- t1 has a key which t2 doesn't have, fail.
                if v2 == nil then
                    return false
                end
                t2keys[k1] = nil
                if not recurse(v1, v2) then
                    return false
                end
            end
        end
        -- if t2 has a key which t1 doesn't have, fail.
        if next(t2keys) then
            return false
        end
        return true
    end
    return recurse(table1, table2)
end

function table.join(t1, t2)
    -- Get the current length of t1, assuming it may have array elements
    local t1Length = #t1
    local result = table.shallowCopy(t1)

    -- Append array-like elements from t2
    for i, v in ipairs(t2) do
        result[t1Length + i] = v
    end

    -- Copy or override key-value pairs from t2 for dictionaries
    for k, v in pairs(t2) do
        if type(k) ~= "number" then
            result[k] = v
        end
    end

    return result
end

-- Math Operations

function love.math.mapClamp(value, srcMin, srcMax, tgtMin, tgtMax)
    -- Map value from the source range to the target range
    local mappedValue = tgtMin + (value - srcMin) * (tgtMax - tgtMin) / (srcMax - srcMin)
    -- Clamp the mapped value within the target range
    return math.max(tgtMin, math.min(mappedValue, tgtMax))
end

