local TableExtras = {}

-- Counts the number of elements in a table (Note: Use length operator for arrays)
function TableExtras.count(tbl: {[any]: any}): number
    local count = 0
    for _, _ in tbl do
        count += 1
    end
    return count
end

-- Swaps two values in a table
function TableExtras.swap(tbl: {[any]: any}, i1: any, i2: any): nil
    local tmp = tbl[i1]
    tbl[i1] = tbl[i2]
    tbl[i2] = tmp
end

-- Reverse a table's values
function TableExtras.reverse(tbl: {[any]: any}): {[any]: any}
    local size = #tbl
    for index = 1, size // 2 do
        TableExtras.swap(tbl, index, (size + 1) - index)
    end
end

-- Demand a value from a table key, if no value exists at the key then create it
function TableExtras.demand(tbl: {[any]: any}, key: any, default: any): any
    local value = tbl[key]
    if value == nil then
        tbl[key] = default
        value = default
    end
    return value
end

-- Source: https://create.roblox.com/docs/luau/tables#deep-clones
-- Creates a deep copy of a given table
function TableExtras.deepCopy(tbl): {[any]: any}
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