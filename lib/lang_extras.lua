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

