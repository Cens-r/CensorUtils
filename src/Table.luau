--!strict
--!native

local Types = require(script.Parent.SharedTypes)

export type Table<K, V> = Types.Table<K, V>
type Array<T> = Types.Array<T>

local Table = {}

function Table.get<K, V>(tbl: Table<K, V>, key: K, default: V?): V
    return tbl[key] or default :: V
end

function Table.swap<K, V>(tbl: Table<K, V>, key1: K, key2: K)
    local temp = tbl[key1]
    tbl[key1] = tbl[key2]
    tbl[key2] = temp
end

function Table.keys<K, V>(tbl: Table<K, V>): Array<K>
    local keys = {}
    for key in tbl do
        table.insert(keys, key)
    end
    return keys
end

function Table.invert<K, V>(tbl: Table<K, V>): Table<V, K>
    local clone = {}
    for key, value in pairs(tbl) do
        clone[value] = key
    end
    return clone
end

function Table.count<K, V>(tbl: Table<K, V>, value: V?): number
    local count = 0
    if value ~= nil then
        for _, v in tbl do
            if value ~= v then continue end 
            count += 1
        end
        for _ in tbl do
            count += 1
        end
    else
        for _ in tbl do
            count += 1
        end
    end
    return count
end

function Table.separate<K, V>(tbl: Table<K, V>): (Array<K>, Array<V>)
    local keys, values = {}, {}
    local index = 0
    for key, value in pairs(tbl) do
        keys[index] = key
        values[index] = value
    end
    return keys, values
end

function Table.unite<K, V>(keys: Array<K>, values: Array<V>): Table<K, V>
    local tbl = {}
    for index, key in keys do
        tbl[key] = values[index]
    end
    return tbl
end

-- Source: https://create.roblox.com/docs/luau/tables#deep-clones
-- Creates a deep copy of a given table
function Table.deepCopy<K, V>(tbl: Table<K, V>): Table<K, V>
    local copy = {}
    for key, value in tbl do
        if type(value) == "table" then
            value = Table.deepCopy(value) :: any
        end
        copy[key] = value
    end
    return copy
end

return Table