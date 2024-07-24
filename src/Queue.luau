local Queue = {}
Queue.__index = Queue

-- Queue Constructor
function Queue.new()
    local queue = {
        type = "Queue",
        Queue = {},
        BackIndex = 0
    }
    return setmetatable(queue, Queue)
end

-- Returns whether or not the queue is empty
function Queue:empty()
    return (self.BackIndex == 0)
end

-- Returns the size of the queue
function Queue:size()
    return self.BackIndex
end

-- Access the next element in the queue
function Queue:front()
    if self:empty() then
        return warn("Can't get front element: "..self.type.." is empty!")
    end
    return self.Queue[1]
end

-- Access the last element in the queue
function Queue:back()
    if self:empty() then
        return warn("Can't get back element: "..self.type.." is empty!")
    end
    return self.Queue[self.BackIndex]
end

-- Adds element to the back of the queue
function Queue:push(value: any)
    table.insert(self.Queue, value)
    self.BackIndex += 1
end

-- Removes element from the front of the queue
function Queue:pop()
    if not self:empty() then
        table.remove(self.Queue, 1)
        self.BackIndex -= 1
    else
        warn("Can't pop element: "..self.type.." is empty!")
    end
end

return Queue