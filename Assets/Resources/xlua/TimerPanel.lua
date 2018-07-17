-- FileName: 
-- Author:qiaoba
-- Date:2018-05-18 15:24:47
-- Purpose: 文件描述，请修改

local _timePanelInstance = nil

TimerPanel = class("TimerPanel")

local _timePanelInstance = nil
TimerPanel.getInstance = function ( ... )
    if (_timePanelInstance == nil) then 
        _timePanelInstance = TimerPanel.new()
        _timePanelInstance:create()
    end
    return _timePanelInstance
end

function TimerPanel:ctor()
    self._timePointImage = nil    --Image
    self._timeText = nil          --Text
    self._time = 10               --time
    self._timer = 10              --float
    self._isOnTimer = nil         --boolen
end

function TimerPanel:setTimePointImage(value)
	self._timePointImage = value
end

function TimerPanel:getTimePointImage()
	return self._timePointImage
end

function TimerPanel:setTimeText(value)
	self._timeText = value
end

function TimerPanel:getTimeText()
	return self._timeText
end

function TimerPanel:setIsOnTimer(value)
	self._isOnTimer = value
end

function TimerPanel:getIsOnTimer()
	return self._isOnTimer
end


function TimerPanel:Awake( ... )
    self._timePointImage = CS.UnityEngine.GameObject.Find("TimePoint"):GetComponent("Image")
    self._timeText = CS.UnityEngine.GameObject.Find("Time"):GetComponent("Text")
end

function TimerPanel:update( ... )
    print("---------TimePanel:update  self._isOnTimer=",self._isOnTimer)
    if (not self._isOnTimer) then return end
       
    if (self._timer > 0) then
        self._timer  = self._timer - CS.UnityEngine.Time.deltaTime
        self._timeText.text =  math.floor(self._timer)
        if (self._timer < 0) then 
            GameManager.getInstance():OverTimer()
        end
    end
end

function TimerPanel:UpdateTimer( player )
    --以后我们需要服务器获得Time的值
    print("---------TimePanel:UpdateTimer")
    self._time = 9;
    self._timer = self._time;
    self._isOnTimer = true;
    self._timeText.text = tostring(self._timer)
    -- _timePointImage.sprite = Resources.Load<Sprite>("UIs/Time/TimePoint" + player);
    self._timePointImage.sprite = CS.UnityEngine.Resources.Load("UIs/Time/TimePoint" .. (player-1),typeof(CS.UnityEngine.Sprite))
end

function TimerPanel:create( ... )
    self:Awake()
end






