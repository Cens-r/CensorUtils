--!strict
--!native

local Types = require(script.Parent.SharedTypes)
local Array = require(script.Parent.Array)

local Methods = {}
local Metamethods = {
    __index = Methods,
    __len = function (self)
        return self.__size
    end
}

local Queue = setmetatable({}, { __index = Methods })
export type Queue<T> = typeof(setmetatable({} :: Types.QueueStruct<T>, Metamethods))

function Queue.new(capacity: number?): Queue<any>
    local array = table.create(capacity or 0)
    local struct: Types.QueueStruct<any> = {
        __type = Types.Queue,
        __capacity = capacity or -1,
        __size = 0,
        __front = 0,
        __back = 0,
        __array = array :: Types.Array<any>
    }
    return setmetatable(struct, Metamethods)
end

function Methods.peek<T>(self: Queue<T>): T?
    return self.__array[self.__front]
end

function Methods.full<T>(self: Queue<T>)
    return (self.__capacity ~= -1) and (self.__size >= self.__capacity)
end

function Methods.wipe<T>(self: Queue<T>)
    table.clear(self.__array)
    self.__size = 0
    self.__front = 0
    self.__back = 0
end

local function increment(value: number, max: number, n: number?): number
    n = n or 1
    if max <= 0 then return value + (n :: number) end
    return (value % max) + (n :: number)
end

function Methods.push<T>(self: Queue<T>, value: T)
    local index = increment(self.__front, self.__capacity)
    if self:full() then
        self.__back = increment(self.__back, self.__capacity)
    else
        self.__size += 1
        if self.__back == 0 then
            self.__back = 1
        end
	end
	self.__front = index
    self.__array[index] = value
end

function Methods.pop<T>(self: Queue<T>): T?
    if self.__size <= 0 then return end
    local index = self.__back
    local value = self.__array[index]
    self.__array[index] = nil
    self.__size -= 1
    if self.__size == 0 then
        self.__front = 0
        self.__back = 0
    else
        self.__back = increment(index, self.__capacity, 1)
    end
    return value
end

function Methods.get<T>(self: Queue<T>): Types.Array<T>
    local rotated = Array.rotate(self.__array, -self.__front)
    return Array.strip(rotated)
end

function Methods.set<T>(self: Queue<T>, content: Types.Array<T>)
    local upper = #content
    if upper > 0 then
        if self.__capacity < 0 then
            self.__array = table.clone(content)
            self.__size = upper
        else
            local lower = math.max(1, (upper - self.__capacity) + 1)
            self.__array = table.move(content, lower, upper, 1, {})
            self.__size = upper - (lower - 1)
        end
        self.__front = self.__size
        self.__back = 1
    else
        self:wipe()
    end
end

return Queue