

-- typeof(List<int>)=System.Collections.Generic.List`1[System.Int32]
-- typeof(List<String>)=System.Collections.Generic.List`1[System.String]
-- typeof(List<Image>)=System.Collections.Generic.List`1[UnityEngine.UI.Image]
-- typeof(Dictionary<string, Transform>)=System.Collections.Generic.Dictionary`2[System.String,UnityEngine.Transform]
-- typeof(Dictionary<string, Sprite>)=System.Collections.Generic.Dictionary`2[System.String,UnityEngine.Sprite]



-- lua中创建list
-- local lst_str = CS.System.Collections.Generic["List`1[System.String]"]()
-- local lst_int = CS.System.Collections.Generic["List`1[System.Int32]"]()
-- local lst_image = CS.System.Collections.Generic["List`1[UnityEngine.UI.Image]"]()

-- 打印table结构的key
function doprint( data,key )
	for k,v in pairs(data) do
		if (key) then
            print(string.format("%s.%s",key,k))
        else
			print(k)
		end
    
        if (type(v)=="table") then
			local newkey = (key or "") .. "." .. k
			doprint(v,newkey)
		end
	end
end


-- data = {
--     1 = "sdfsaf",
--     2 = "dffgfg",
--     3 = {
--         1 = "fdsfds",
--     },
-- }

logger = {}

function logger.debug(value)
	-- 打印table时行首有几个Tab键
	-- local function getTabBlank( count )
	-- 	local s = ''
	-- 	for i=1,count do
	-- 		s = s .. '	'
	-- 	end
	-- 	return s
	-- end

    -- local function tableToString( data,str,level )
	-- 	str = str or ""
	-- 	level = level or 0
	-- 	if (type(data) == 'table') then
	-- 		str = str .. "{\n"
	-- 		for k,v in pairs(data) do
	-- 			str = str .. getTabBlank(level)
    --             str = str .. tostring(k) .. " = "
	-- 			if (type(v) == 'table') then
    --                 str = tableToString(v,str,level+1)
    --             elseif (type(v) == 'boolen') then
    --                 local str_tmp = v or "true" or "false"
    --                 str = str .. str_tmp .. ",\n" 
    --             else
    --                 str = str .. tostring(v) ..",\n" 
    --             end
	-- 		end
	-- 		str = str .. getTabBlank(level-1)
	-- 		str = str .. "},\n"
    --     else
    --         str = str .. 'data' .. ",\n"
    --     end
    --     return str
    -- end

    -- local tableStr = tableToString(value)
    -- print(tableStr)
end








---
-- 将一个table转化成字符串
-- @function [parent=#Util] tableToString
-- @param #table t
-- @return #string
function tableToString_(t, level)
	local ret = ''
	if level == nil then
		level = 0
	end

	local function echoTabs(count)
		local s = ''
		for i = 1, count do
			s = s .. '\t'
		end
		return s
	end

	local dataType = type(t)
	if dataType == 'table' then
		ret = ret .. echoTabs(level) .. '{\n'
		for k, v in pairs(t) do
			ret = ret .. echoTabs(level + 1) .. '[' .. tableToString_(k) .. ']'
			ret = ret .. ' = '
			ret = ret .. tableToString_(v, level + 1)
			ret = ret .. ',\n'
		end
		ret = ret .. echoTabs(level) .. '}'
	elseif dataType == 'string' then
		return '"' .. t .. '"'
	elseif dataType == 'boolean' then
		return t and "true" or "false"
    elseif dataType == 'userdata' then
        return '"' .. tostring(t) .. '"'
    elseif dataType == 'function' then
        return '"' .. tostring(t) .. '"'
	else
		return t
	end
	return ret
end


--
-- 日志的实际输出函数
function log(...)
	-- local argLength = select('#', ...)
	-- local args = {}
	-- for i = 1, argLength do
	-- 	local arg = select(i, ...)
	-- 	if type(arg) == 'table' then
	-- 		arg = tableToString_(arg)
	-- 	end
	-- 	args[i] = arg
	-- end

	-- local message = ""
	-- if #args == 1 then
	-- 	message = args[1]
	-- else
	-- 	message = string.format(unpack(args))
	-- end
	-- print(message)
end


local data = {
	{1,2,3},
	{"aa","bb"},
	{"a",{false,{100}}},
	"hello world",
}
-- logger.debug({value = data})

-- log(data)