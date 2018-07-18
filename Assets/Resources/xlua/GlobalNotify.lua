GlobalNotify = {}

local m_notify = {}


-- 添加一个通知对象
-- target：
-- name:通知对象的名称
-- fn_cb:回调函数
function GlobalNotify.addObserver( target,event_name,fn_cb )
    m_notify[target] = m_notify[target] or {}
    m_notify[target][event_name] = fn_cb
end

-- 通知事件
function GlobalNotify.postNotify( event_name,params )
    for k,v in pairs(m_notify) do
        for name,fn_cb in pairs(v) do
            if (name == event_name) then
                fn_cb(params)
            end
        end
    end
end