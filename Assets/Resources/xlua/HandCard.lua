-- FileName: 
-- Author:qiaoba
-- Date:2018-05-25 11:23:20
-- Purpose: 文件描述，请修改


HandCard = class("HandCard")


function HandCard:ctor()
    self._handCardImage = nil    --Image
    self._rectTF = nil           --RectTransform
    self._card = nil             --Card
    self._target = nil
end

function HandCard:getHandCardImage()
    return self._handCardImage
end

function HandCard:setHandCardImage(value)
	self._handCardImage = value
end

function HandCard:getCard()
    return self._card
end

function HandCard:setCard(value)
	self._card = value
end

function HandCard:getRectTF()
    return self._rectTF
end

function HandCard:setRectTF(value)
	self._rectTF = value
end


function HandCard:Awake()
    print("------------HandCard:Awake-1")
    self._handCardImage = self._target.transform:Find("Card"):GetComponent("Image")
    print("------------HandCard:Awake-2")
    self._rectTF = self._target.transform:Find("Card"):GetComponent("RectTransform")
end

function HandCard:Start()
    self:InitLocation()
end

function HandCard:InitLocation()
    print("------------HandCard:InitLocation1")
    self._rectTF.sizeDelta = self._target.transform.parent:GetComponent("GridLayoutGroup").cellSize
    self._target.transform.localRotation = CS.UnityEngine.Quaternion.identity
    self._target.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
end

function HandCard:getTarget( ... )
    return self._target
end

function HandCard:create( target )
    self._target = target
    self:Awake()
    -- HandCard实例化后，因为没有添加到父节点，直接调用InitLocation会报错找不到parent，这里屏蔽start
    -- 创建HandCard并添加父节点后，有手动调用InitLocation
    -- self:Start()
end

