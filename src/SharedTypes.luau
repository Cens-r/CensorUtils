--!strict

local function CustomType(name: string)
    local proxy = newproxy(true)
    local meta = getmetatable(proxy)
    meta.__tostring = function()
        return name
    end
    return proxy
end

local SharedTypes = {}

function SharedTypes.typeof(value: any): string
    local valueType = typeof(value)
    if valueType == "table" then
        local objectType = value.__type
        if objectType then return objectType end
    end
    return valueType
end

export type CompareCallback<T> = (a: T, b: T) -> boolean

export type Array<V> = {[number]: V}
export type Table<K, V> = {[K]: V}

SharedTypes.Stack = CustomType("Stack")
export type StackStruct<T> = {
    __type: any,
    __size: number,
    __array: Array<T>
}

SharedTypes.Heap = CustomType("Heap")
export type HeapStruct<T> = {
    __type: any,
    __size: number,
    __array: Array<T>,
    __compare: CompareCallback<T>
}

SharedTypes.Queue = CustomType("Queue")
export type QueueStruct<T> = {
    __type: any,
    __capacity: number,
    __size: number,
    __front: number,
    __back: number,
    __array: Array<T>
}

SharedTypes.PriorityQueue = CustomType("PriorityQueue")
export type PriorityQueueStruct<T> = {
}

return SharedTypes