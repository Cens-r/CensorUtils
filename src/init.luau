
local CensorUtils = {}

local Table = require(script.Table)
export type Table<K, V> = Table.Table<K, V>
CensorUtils.Table = Table

local Array = require(script.Array)
export type Array<T> = Array.Array<T>
CensorUtils.Array = Array

local Stack = require(script.Stack)
export type Stack<T> = Stack.Stack<T>
CensorUtils.Stack = Stack

local Queue = require(script.Queue)
export type Queue<T> = Queue.Queue<T>
CensorUtils.Queue = Queue

return CensorUtils