local CensorUtils = {}
CensorUtils.LoadedModules = {}

-- Returns whether or not the given module is loaded
function CensorUtils.IsLoaded(moduleName)
    return CensorUtils.LoadedModules[moduleName] ~= nil
end

-- Returns the number of times a given module has been required
function CensorUtils.RequireCount(moduleName)
    return CensorUtils.LoadedModules[moduleName] or 0
end

-- Custom typeof function for my modules
function CensorUtils.typeof(value)
    local rawType = typeof(value)
    if rawType == "table" and value.type then
        return value.type
    end
    return rawType
end

-- Lazy Module Loading:
return setmetatable(CensorUtils, {
    __index = function (tbl, index)
        local module = script:FindFirstChild(index, true)
        if module then
            CensorUtils.LoadedModules[index] = if CensorUtils.LoadedModules[index] then
                (CensorUtils.LoadedModules[index] + 1) else 0
            return require(module)
        end
        return rawget(tbl, index)
    end
})