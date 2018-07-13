local util = require 'xlua.util'

UtilTools = {}


-- 继承了MonoBehaviour的类只能作为组件被添加，不能使用new创建类的实例
function UtilTools.yield_return( ... )
    -- 把Coroutine_Runner脚本添加到Canvas上不删除
    local canvas = CS.UnityEngine.GameObject.Find("Canvas")
    local cs_coroutine_runner = canvas.transform:Find("Coroutine_Runner")
    if (not cs_coroutine_runner) then
        cs_coroutine_runner = canvas:AddComponent(typeof(CS.Coroutine_Runner))
    end

    local function async_yield_return(to_yield, cb)
        cs_coroutine_runner:YieldAndCallback(to_yield, cb)
    end
    return util.async_to_sync(async_yield_return)
end


-- data = {
--     1 = "sdfsaf",
--     2 = "dffgfg",
--     3 = {
--         1 = "fdsfds",
--     },
-- }
function logger.debug(value)
    -- local function tableToString( data,str )
    --     str = str or ""
    
    --     if (type(data) == 'table') then
    --         str = str .. tostring(data) .. " = " .. "{\n"
    --         for k,v in pairs(data) do
    --             str = str .. tostring(k) .. " = "
    --             if (type(v) == 'table') then
    --                 return tableToString(v,str)
    --             elseif (type(v) == 'boolen') then
    --                 local str_tmp = v or "true" or "false"
    --                 str = str .. str_tmp .. ",\n" 
    --             else
    --                 str = str .. tostring(v) ..",\n" 
    --             end
    --         end
    --         str = str .. "\n}"
    --     else
    --         str = str .. tostring(k) .. " = " .. tostring(v) .. ",\n"
    --     end
    --     return str
    -- end


    -- local tableStr = tableToString(value)
    -- print(tableStr)
end