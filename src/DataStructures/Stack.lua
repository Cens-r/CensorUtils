local Stack = {}
Stack.__index = Stack

-- Stack Constructor
function Stack.new()
    local stackTable = {
        type = "Stack",
        Stack = {},
        TopIndex = 0
    }
    return setmetatable(stackTable, Stack)
end

-- Returns whether or not the stack is empty
function Stack:empty()
    return (self.TopIndex == 0)
end

-- Returns the size of the stack
function Stack:size()
    return self.TopIndex
end

-- Returns the top element of the stack
function Stack:top()
    return self.Stack[self.TopIndex]
end

-- Adds the value to the top of the stack
function Stack:push(value: any)
    table.insert(self.Stack, value)
    self.TopIndex += 1
end

-- Removes the value at the top of the stack
function Stack:pop()
    if not self:empty() then
        table.remove(self.Stack, self.TopIndex)
        self.TopIndex -= 1
    else
        warn("Can't pop element: Stack is empty!")
    end
end

return Stack