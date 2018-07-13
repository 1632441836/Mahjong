-- FileName: 
-- Author:yangna
-- Date:2018-05-18 15:13:26
-- Purpose: 牌

Card = class("Card")

function Card:ctor()
    self._name = nil        --string 牌的名字
    self._size = nil        --int 牌的数字
    self._cardMark = nil    --string牌的类型
    self._imageName = nil   --string
    self._soundName = nil   --string
end

function Card:setName(value)
	self._name = value
end

function Card:getName()
	return self._name
end

function Card:setSize(value)
	self._size = value
end

function Card:getSize()
	return self._size
end

function Card:setCardMark(value)
	self._cardMark = value
end

function Card:getCardMark()
	return self._cardMark
end

function Card:setImageName(value)
	self._imageName = value
end

function Card:getImageName()
	return self._imageName
end

function Card:setSoundName(value)
	self._soundName = value
end

function Card:getSoundName()
	return self._soundName
end

function Card:create( name,size,cardMark,imageName,soundName )
    self._name = name 
    self._size = size 
    self._cardMark = cardMark
    self._imageName = imageName
    self._soundName = soundName
end