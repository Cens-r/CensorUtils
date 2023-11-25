local TableExtras = {}

-- Counts the number of elements in a table
function TableExtras.count(tbl)
    local count = 0
    for _, _ in tbl do
        count += 1
    end
    return count
end

-- Swaps two values in a table
function TableExtras.swap(tbl, i1, i2)
    local tmp = tbl[i1]
    tbl[i1] = tbl[i2]
    tbl[i2] = tmp
end

-- Reverse an array's values
function TableExtras.reverse(tbl)
    local size = #tbl
    for index = 1, size // 2 do
        TableExtras.swap(tbl, index, (size + 1) - index)
    end
end

-- Source: https://create.roblox.com/docs/luau/tables#deep-clones
-- Returns a deep copy of a given table
function TableExtras.deepCopy(tbl)
    local copy = {}
    for key, value in tbl do
        if type(value) == "table" then
            value = TableExtras.deepCopy(value)
        end
        copy[key] = value
    end
    return copy
end

return TableExtras