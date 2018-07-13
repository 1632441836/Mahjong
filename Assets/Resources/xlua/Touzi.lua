-- FileName: 
-- Author:yangna
-- Date:2018-05-22 17:16:35
-- Purpose: 文件描述，请修改


Touzi = class("Touzi")

local _touziInstance = nil 
Touzi.getInstance = function ( ... )
    if (_touziInstance == nil) then
        _touziInstance = Touzi.new()
        _touziInstance:create()
    end
    return _touziInstance
end

function Touzi:setTouziOne( value )
   self._touziOne = value
end 

function Touzi:getTouziOne( ... )
   return self._touziOne 
end 

function Touzi:setTouziTwo( value )
    self._touziTwo = value
 end 
 
 function Touzi:getTouziTwo( ... )
    return self._touziTwo 
 end 

function Touzi:Awake()
    local touzi = CS.UnityEngine.GameObject.Find("Touzi")
    self._touziOne = UGUIAnimation.new()
    self._touziOne:create(touzi.transform:Find("1"))
    self._touziTwo = UGUIAnimation.new()
    self._touziTwo:create(touzi.transform:Find("2"))
end

function Touzi:Update( ... )
    if (self._touziOne) then
        self._touziOne:Update()
    end
    if (self._touziTwo) then
        self._touziTwo:Update()
    end
end

function Touzi:PlayerAllAnimation()
    self._touziOne:Play()
    self._touziTwo:PlayReverse()
end

function Touzi:TouziShow(value)
    local touzi = CS.UnityEngine.GameObject.Find("Touzi")
    touzi.transform:Find("1").gameObject:SetActive(value)
    touzi.transform:Find("2").gameObject:SetActive(value)
end

function Touzi:ctor()
    self._touziOne = nil
    self._touziTwo = nil
end


function Touzi:create( ... )
    self:Awake()
end