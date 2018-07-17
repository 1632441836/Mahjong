

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



logger = {}

function logger.debug(value)

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


