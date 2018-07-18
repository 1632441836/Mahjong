local util = require 'xlua.util'

UtilTools = {}


-- 继承了MonoBehaviour的类只能作为组件被添加，不能使用new创建类的实例
function UtilTools.yield_return( ... )
    -- 把Coroutine_Runner脚本添加到Canvas上不删除
    local canvas = CS.UnityEngine.GameObject.Find("Canvas")
    local cs_coroutine_runner = canvas:GetComponent("Coroutine_Runner")
    if (not cs_coroutine_runner) then
        cs_coroutine_runner = canvas:AddComponent(typeof(CS.Coroutine_Runner))
    end

    local function async_yield_return(to_yield, cb)
        cs_coroutine_runner:YieldAndCallback(to_yield, cb)
    end
    return util.async_to_sync(async_yield_return)
end



function logger.debug(value)
 
end