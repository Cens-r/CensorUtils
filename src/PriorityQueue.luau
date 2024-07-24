
local Queue = require(script.Parent.Queue)

local PriorityQueue = setmetatable({}, Queue)
PriorityQueue.__index = PriorityQueue

-- Priority Queue Constructor
function PriorityQueue.new(compareFunc: (value: any, element: any) -> boolean)
    if not compareFunc then
        return warn("Compare function not given for PriorityQueue!")
    end    
    local queue = Queue.new()
    queue.type = "PriorityQueue"
    queue.Compare = compareFunc
    return setmetatable(queue, PriorityQueue)
end

-- Adds an element to the queue using the queue's compare function
function PriorityQueue:push(value: any)
    local queued = false
    for index, element in ipairs(self.Queue) do
        if self.Compare(value, element) then
            table.insert(self.Queue, index, value)
            self.BackIndex += 1
            queued = true
            break
        end
    end
    if not queued then
        table.insert(self.Queue, value)
        self.BackIndex += 1
    end
end

return PriorityQueue