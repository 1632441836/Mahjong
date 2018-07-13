-- FileName: 
-- Author:yangna
-- Date:2018-05-25 16:08:48
-- Purpose: 文件描述，请修改


ListenCardList = class("ListenCardList")


function ListenCardList:ctor()
    self._pengButton = nil    --Button
    self._gangButton = nil    --Button
    self._huButton = nil      --Button
    self._guoButton = nil     --Button
end

function ListenCardList:setPengButton(value)
	self._pengButton = value
end

function ListenCardList:getPengButton()
    return self._pengButton
end

function ListenCardList:setGangButton(value)
	self._gangButton = value
end

function ListenCardList:getGangButton()
    return self._gangButton
end

function ListenCardList:setHuButton(value)
	self._huButton = value
end

function ListenCardList:getHuButton()
    return self._huButton
end

function ListenCardList:setGuoButton(value)
	self._guoButton = value
end

function ListenCardList:getGuoButton()
    return self._guoButton
end

function ListenCardList:Awake()
    self._pengButton = self._target.transform:Find("Grid/Peng"):GetComponent("Button")
    self._gangButton = self._target.transform:Find("Grid/Gang"):GetComponent("Button")
    self._huButton = self._target.transform:Find("Grid/Hu"):GetComponent("Button")
    self._guoButton = self._target.transform:Find("Grid/Guo"):GetComponent("Button")
end

function ListenCardList:Start()
    self._pengButton.onClick:AddListener(function ( ... )
        self._target.transform.parent:SendMessage("PengCard")
    end)

    self._gangButton.onClick:AddListener(function ( ... )
        self._target.transform.parent:SendMessage("GangCard")
    end)
  
    self._huButton.onClick:AddListener(function ( ... )
        self._target.transform.parent:SendMessage("HuCard")
    end)

    self._guoButton.onClick:AddListener(function ( ... )
        self._target.transform.parent:SendMessage("GuoCard")
    end)
end

function ListenCardList:create( target )
    self._target = target
    self:Awake()
    self:Start()
end

