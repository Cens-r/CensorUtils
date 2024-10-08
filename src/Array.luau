--!strict
--!native

local Types = require(script.Parent.SharedTypes)
local Table = require(script.Parent.Table)

export type Array<T> = Types.Array<T>
type CompareCallback<T> = Types.CompareCallback<T>
type BinaryCallback<V, T> = (a: V, b: T, i: number) -> number

local Array = {}
Array.BinaryResult = {
    Less = -1,
    Equal = 0,
    Greater = 1
}

local BINARY_COMPARE: BinaryCallback<any, any> = function(a, b)
    if a == b then
        return Array.BinaryResult.Equal
    elseif a > b then
        return Array.BinaryResult.Greater
    else
        return Array.BinaryResult.Less
    end
end

function Array.strip<T>(array: Array<T>)
    local first = next(array)
    if first == nil then return {} end

    local last = #array
    for i = last, first, -1 do
        if array[i] ~= nil then break end
        last -= 1
    end
    return table.move(array, first, last, 1, {})
end

function Array.extend<T>(array: Array<T>, other: Array<T>): Array<T>
    local offset = #array
    local clone = table.clone(array)
    for index, value in other do
        clone[index + offset] = value
    end
    return clone
end

function Array.reverse<T>(array: Array<T>, start: number?, finish: number?): Array<T>
    local size = #array

    if size == 0 then return {} end
    local front = if start then math.clamp(start, 1, size) else 1
    local back = if finish then math.clamp(finish, front, size) else size

    local clone = table.clone(array)
    if size == 0 then return clone end
    while front < back do
        Table.swap(clone, front, back)
        front += 1
        back -= 1
    end
    return clone
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

function Array.find<T, V>(array: Array<T>, value: V, compare: BinaryCallback<V, T>?, start: number?, finish: number?): number?
    local low = start or 1
    local high = finish or #array
    compare = compare or BINARY_COMPARE

    while high >= low do
        local mid = (low + high) // 2
        local result = (compare :: BinaryCallback<V, T>)(value, array[mid], mid)
        if result == Array.BinaryResult.Equal then
            return mid
        elseif result == Array.BinaryResult.Greater then
            low = mid + 1
        elseif result == Array.BinaryResult.Less then
            high = mid - 1
        else
            return warn("Array.find() | Comparison callback returned an invalid value!", debug.traceback())
        end
    end
    return nil
end

return Array