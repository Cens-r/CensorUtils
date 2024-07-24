--!strict
--!native

local Types = require(script.Parent.SharedTypes)
local Table = require(script.Parent.Table)

export type Array<T> = Types.Array<T>
type CompareCallback<T> = (a: T, b: T) -> boolean
type BinaryCallback<T> = (a: T, b: T) -> number

local Array = {}
Array.BinaryResult = {
    Less = -1,
    Equal = 0,
    Greater = 1
}

local BASIC_COMPARE: CompareCallback<any> = function(a, b)
    return a < b
end
local BINARY_COMPARE: BinaryCallback<any> = function(a, b)
    if a == b then
        return Array.BinaryResult.Equal
    elseif a > b then
        return Array.BinaryResult.Greater
    else
        return Array.BinaryResult.Less
    end
end

function Array.reverse<T>(array: Array<T>, start: number?, finish: number?): Array<T>
    local size = #array
    local clone = table.clone(array)

    local front = if start then math.clamp(start, 1, size) else 1
    local back = if finish then math.clamp(finish, front, size) else size

    if size == 0 then return clone end
    while front < back do
        Table.swap(clone, front, back)
        front += 1
        back -= 1
    end
    return {}
end

function Array.rotate<T>(array: Array<T>, shift: number): Array<T>
    local size = #array
	shift = shift % size
	local clone = table.clone(array)
	if shift == 0 then return clone end
	
	clone = Array.reverse(clone, 1, size - shift);
	clone = Array.reverse(clone, size - (shift - 1), size);
	clone = Array.reverse(clone, 1, size);
	return clone
end

local function partition<T>(array: Array<T>, compare: CompareCallback<T>, start: number, finish: number): number
    local value = array[finish] -- Pivot's Value
    local i = start - 1

    for j = start, finish do
        if compare(array[j], value) then
            i += 1
            Table.swap(array, i, j)
        end
    end

    i += 1
    Table.swap(array, i, finish)
    return i -- New Pivot Index
end

function Array.sort<T>(array: Array<T>, compare: CompareCallback<T>?, start: number?, finish: number?)
    start = start or 1
    finish = finish or #array
    if start > finish then return end
   
    compare = compare or BASIC_COMPARE

    local pivot = partition(array, compare :: CompareCallback<T>, start :: number, finish :: number)
    Array.sort(array, compare, start, pivot - 1)
    Array.sort(array, compare, pivot + 1, finish)
end

function Array.find<T>(array: Array<T>, value: T, compare: BinaryCallback<T>?, start: number?, finish: number?): number?
    local low = start or 1
    local high = finish or #array
    compare = compare or BINARY_COMPARE

    while high >= low do
        local mid = (low + high) // 2
        local result = (compare :: BinaryCallback<T>)(array[mid], value)
        if result == Array.BinaryResult.Equal then
            return mid
        elseif result == Array.BinaryResult.Greater then
            high = mid - 1
        elseif result == Array.BinaryResult.Less then
            low = mid + 1
        else
            return warn("Array.find() | Comparison callback returned an invalid value!", debug.traceback())
        end
    end
    return nil
end

return Array