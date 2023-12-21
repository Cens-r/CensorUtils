local TableExtras = {}

-- Types:
export type Table = {[any]: any}
export type Array = {[number]: any}

-- Returns an array of duplicate values in the given table
function TableExtras.duplicates(tbl: Table): Array
	local dupeArray, seenTable = {}, {}
	for _, element in tbl do
		if seenTable[element] then
			continue
		elseif seenTable[element] == false then
			seenTable[element] = true
			table.insert(dupeArray, element)
			continue
		end
		seenTable[element] = false
	end
	return dupeArray
end

-- Returns an array thats been rotated n places
function TableExtras.rotate(tbl: Array, n: number): Array
	local size = #tbl
	n = n % size
	local tblClone = table.clone(tbl)
	if n == 0 then return tblClone end
	
	tblClone = TableExtras.reverse(tblClone, 1, size - n);
	tblClone = TableExtras.reverse(tblClone, size - (n - 1), size);
	tblClone = TableExtras.reverse(tblClone, 1, size);
	return tblClone
end

-- Returns a table of value-key pairs
function TableExtras.invert(tbl: Table): Table
	local tblClone = {}
	for key, value in tbl do
		tblClone[value] = key
	end
	return tblClone
end

-- Returns an array of keys and an array of values of a given table
function TableExtras.seperate(tbl: Table): (Array, Array)
	local keys, values = {}, {}
	local index = 0
	for key, value in tbl do
		keys[index] = key
		values[index] = value
	end
	return keys, values
end

-- Returns a table of key-value pairs, based on their indexes
function TableExtras.unite(keys: Array, values: Array): Table
	local tbl = {}
	for index, key in keys do
		tbl[key] = values[index]
	end
	return tbl
end

-- Returns an array of the table's keys
function TableExtras.keys(tbl: Table): Array
	local keys = {}
	for index, _ in tbl do
		table.insert(keys, index)
	end
	return keys
end

-- Counts the number of elements in a table (Note: Use length operator for arrays)
function TableExtras.count(tbl: Table): number
    local count = 0
    for _, _ in tbl do
        count += 1
    end
    return count
end

-- Swaps two values in a table
function TableExtras.swap(tbl: Table, i1: any, i2: any)
    local tmp = tbl[i1]
    tbl[i1] = tbl[i2]
    tbl[i2] = tmp
end

-- Reverse a table's values, optionally give a starting and ending index
function TableExtras.reverse(tbl, i: number?, j: number?)
	local size = #tbl
	local firstIndex = if i then math.clamp(i, 1, size) else 1
	local lastIndex = if j then math.clamp(j, firstIndex, size) else size

	local tblClone = table.clone(tbl)
	while firstIndex < lastIndex do
		TableExtras.swap(tblClone, firstIndex, lastIndex)
		firstIndex += 1
		lastIndex -= 1
	end
	return tblClone
end

-- Demand a value from a table key, if no value exists at the key then create it
function TableExtras.demand(tbl: Table, key: any, default: any): any
    local value = tbl[key]
    if value == nil then
        tbl[key] = default
        value = default
    end
    return value
end

-- Source: https://create.roblox.com/docs/luau/tables#deep-clones
-- Creates a deep copy of a given table
function TableExtras.deepCopy(tbl: Table): Table
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