--!strict

local Types = require(script.Parent.SharedTypes)

local Methods = {}
local Metamethods = {
    __index = Methods,
    __len = function(self)
        return self.__size
    end
}

local Stack = setmetatable({}, { __index = Methods })
export type Stack<T> = typeof(setmetatable({} :: Types.StackStruct<T>, Metamethods))

function Stack.new(): Stack<any>
    local struct: Types.StackStruct<any> = {
        __type = Types.Stack,
        __size = 0,
        __array = {} :: Types.Array<any>
    }
    return setmetatable(struct, Metamethods)
end

function Methods.peek<T>(self: Stack<T>): T
    return self.__array[self.__size]
end

function Methods.push<T>(self: Stack<T>, value: T)
    self.__size += 1
    self.__array[self.__size] = value
end

function Methods.pop<T>(self: Stack<T>): T
    local value = self.__array[self.__size]
    self.__array[self.__size] = nil
    self.__size -= 1
    return value
end

return Stack