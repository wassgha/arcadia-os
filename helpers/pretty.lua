
function prettyPrint(obj, indent)
    indent = indent or 0  -- Default indentation level
    local indentStr = string.rep("  ", indent)  -- Create indentation string

    if type(obj) == "table" then
        print(indentStr .. "{")
        for k, v in pairs(obj) do
            io.write(indentStr .. "  [" .. tostring(k) .. "] = ")
            prettyPrint(v, indent + 1)
        end
        print(indentStr .. "}")
    else
        print(indentStr .. tostring(obj))
    end
end
