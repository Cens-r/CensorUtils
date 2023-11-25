local TableExtras = require(script.Parent.TableExtras)

local Heap = {}
Heap.__index = Heap

-- Heap types: Min or Max
type HeapType = "MinHeap" | "MaxHeap"
Heap.MinHeap = "MinHeap"
Heap.MaxHeap = "MaxHeap"

local function shouldSwap(heapType: HeapType, v1: any, v2: any)
    if heapType == Heap.MinHeap then
        return v1 > v2
    else
        return v1 < v2
    end
end

local function getLeafTable(heapTable)
    local leafIndex = (heapTable.HeapSize // 2) + 1
    return table.move(heapTable.Heap, leafIndex, heapTable.HeapSize, 1, {})
end



-- Heap Constructor
function Heap.new(heapType: HeapType)
    local heap = {
        type = "Heap",
        Heap = {},
        HeapSize = 0,
        HeapType = heapType
    }
    return setmetatable(heap, Heap)
end

-- Insert an element into a heap
function Heap:insert(value: any)
    self.HeapSize += 1
    local index = self.HeapSize
    self.Heap[index] = value
    Heap.HeapifyUp(self.Heap, index, self.HeapType)
end

-- Remove an element from a heap
function Heap:remove(value: any)
    local valueIndex = self:find(value)
    if valueIndex then
        self.Heap[valueIndex] = self.Heap[self.HeapSize]
        table.remove(self.Heap, self.HeapSize)
        self.HeapSize -= 1
        Heap.Heapify(self.Heap, self.HeapSize, valueIndex, self.HeapType)
    else
        warn(`Couldn't find {value} in heap!`)
    end
end

-- Gets the height of the heap
function Heap:height()
    return math.floor(math.log(self.HeapSize, 2)) + 1
end

-- Linear search of the heap
function Heap:find(value: any)
    for index = 1, self.HeapSize do
        if self.Heap[index] == value then
            return index
        end
    end
    return nil -- Return nil if no value was found
end

-- Gets the minimum value from the heap
function Heap:getMin()
    if self.HeapType == Heap.MinHeap then
        return self.Heap[1]
    else
        local tbl = getLeafTable(self)
        return math.min(table.unpack(tbl))
    end
end

-- Gets the maximum value from the heap
function Heap:getMax()
    if self.HeapType == Heap.MaxHeap then
        return self.Heap[1]
    else
        local tbl = getLeafTable(self)
        return math.max(table.unpack(tbl))
    end
end



-- Heapify's a subtree starting from 'index' in an array
function Heap.Heapify(array, size: number, index: number, heapType: HeapType)
    while 0 < index and index <= size do
        local leftIndex, rightIndex = Heap.GetLeft(index), Heap.GetRight(index)
        local swapIndex = index

        if (leftIndex <= size) and shouldSwap(heapType, array[swapIndex], array[leftIndex]) then
            swapIndex = leftIndex
        end
        if (rightIndex <= size) and shouldSwap(heapType, array[swapIndex], array[rightIndex]) then
            swapIndex = rightIndex
        end
        if swapIndex == index then break end

        TableExtras.swap(array, index, swapIndex)
        index = swapIndex
    end
end

-- Heapify from bottom-up
function Heap.HeapifyUp(array, index, heapType)
    while index > 1 do
        local parentIndex = Heap.GetParent(index)
        if shouldSwap(heapType, array[parentIndex], array[index]) then
            TableExtras.swap(array, index, parentIndex)
            index = parentIndex
        else
            break
        end
    end
end

-- Build heap from an array
function Heap.Build(array, heapType: HeapType?)
    local HeapType = heapType or Heap.MinHeap
    local heapArray = table.clone(array)
    local arraySize = #heapArray
    for index = arraySize // 2, 1, -1 do
        Heap.Heapify(heapArray, arraySize, index, HeapType)
    end

    local heap = Heap.new(HeapType)
    heap.Heap = heapArray
    heap.HeapSize = arraySize
    return heap
end

-- Gets a node's parent index
function Heap.GetParent(index: number)
    return index - math.ceil(index / 2)
end

-- Gets a node's left index
function Heap.GetLeft(index: number)
    return (2 * index)
end

-- Gets a node's right index
function Heap.GetRight(index: number)
    return (2 * index) + 1
end

return Heap