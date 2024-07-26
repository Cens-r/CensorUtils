local Types = require(script.Parent.SharedTypes)

local Methods = {}
local Metamethods = {
    __index = Methods,
    __len = function(self)
        return self.__size
    end
}

local Heap = setmetatable({}, { __index = Methods })
export type Heap<T> = typeof(setmetatable({} :: Types.HeapStruct<T>, Metamethods))

type CompareCallback<T> = Types.CompareCallback<T>
local BASIC_COMPARE: CompareCallback<any> = function(a, b)
    return a < b
end

function Heap.new(compare: CompareCallback<any>?): Heap<any>
    local struct: Types.HeapStruct<any> = {
        __type = Types.Heap,
        __size = 0,
        __array = {} :: Types.Array<any>,
        __compare = compare or BASIC_COMPARE
    }
    return setmetatable(struct, Metamethods)
end

function Heap.heapify<T>(array: Types.Array<T>, compare: CompareCallback<T>?): Heap<T>
    local heap: Heap<T> = Heap.new(compare)
    -- TODO: Implement heapify
    return heap
end

return Heap