-- FileName: 
-- Author:qiaoba
-- Date:2018-05-23 14:18:42
-- Purpose: 管理player对象，playerPanel里面包含HandCardList，AwaitCardList，ChooseFlowerPig，ListenCardList

local util = require 'xlua.util'

PlayerPanel = class("PlayerPanel")


function PlayerPanel:ctor()
    self._target = nil                  --脚本要绑定的目标控件
    self._posText = nil                 --Text
    self._handCarde = nil               --HandCardList
    self._awaitCard = nil               --AwaitCardList
    self._listenCard = nil              --_listenCard
    self._chooseFP = nil                --ChooseFlowerPig
    self._infoHeadImage = nil           --Image
    self._infoDealerImage = nil         --Image
    self._infoFlowerPigImage = nil      --Image
    self._infoNameText = nil            --Text  
    self._infoGoldText = nil            --Text
    self._tempOutCard = nil             --Card
    self._isOnListenCard = false        
    self._isHuCard = false              
    self._isOnChooseFlowerPig = false
    self._myPosIndex = nil              --int
    self._isSelfTouch = false
    self._isPeng = false
    self._isHu = false
    self._isGang = -1        --0是明杠，1是暗杠，2是加杠
end


function PlayerPanel:setPosText( value )
    self._posText = value
end

function PlayerPanel:getPosText( ... )
   return self._posText
end

function PlayerPanel:setInfoHeadImage( value )
    self._infoHeadImage = value
end

function PlayerPanel:getInfoHeadImage( ... )
   return self._infoHeadImage
end

function PlayerPanel:setHandCarde( value )
    self._handCarde = value
end

function PlayerPanel:getHandCarde( ... )
   return self._handCarde
end
 
function PlayerPanel:setAwaitCard( value )
    self._awaitCard = value
end

function PlayerPanel:getAwaitCard( ... )
   return self._awaitCard
end

function PlayerPanel:setMyPosIndex( value )
    self._myPosIndex = value
end

function PlayerPanel:getMyPosIndex( ... )
   return self._myPosIndex
end

function PlayerPanel:setInfoDealerImage( value )
    self._infoDealerImage = value
end

function PlayerPanel:getInfoDealerImage( ... )
   return self._infoDealerImage
end

function PlayerPanel:setInfoNameText( value )
    self._infoNameText = value
end

function PlayerPanel:getInfoNameText( ... )
   return self._infoNameText
end

function PlayerPanel:setInfoGoldText( value )
    self._infoGoldText = value
end

function PlayerPanel:getInfoGoldText( ... )
   return self._infoGoldText
end

function PlayerPanel:setListenCard( value )
    self._listenCard = value
end

function PlayerPanel:getListenCard( ... )
   return self._listenCard
end

function PlayerPanel:setIsOnListenCard( value )
    self._isOnListenCard = value
end

function PlayerPanel:getIsOnListenCard( ... )
   return self._isOnListenCard
end

function PlayerPanel:setChooseFP( value )
    self._chooseFP = value
end

function PlayerPanel:getChooseFP( ... )
   return self._chooseFP
end

function PlayerPanel:setInfoFlowerPigImage( value )
    self._infoFlowerPigImage = value
end

function PlayerPanel:getInfoFlowerPigImage( ... )
   return self._infoFlowerPigImage
end

function PlayerPanel:setIsOnChooseFlowerPig( value )
    self._isOnChooseFlowerPig = value
end

function PlayerPanel:getIsOnChooseFlowerPig( ... )
   return self._isOnChooseFlowerPig
end

function PlayerPanel:setIsHuCard( value )
    self._isHuCard = value
end

function PlayerPanel:getIsHuCard( ... )
   return self._isHuCard
end

-- 听自己摸的牌
function PlayerPanel:ListenTouchCard( card )
    self._isPeng = false
    self._isHu = false
    self._isGang = -1
    local gameInstance = GameManager.getInstance()

    if (self._handCarde:getCurrentFlowerPig() ~= card:getCardMark()) then
        self._tempOutCard = card
        self._isSelfTouch = true
        if (self._handCarde:GetCurrentFlowerPigCount() == 0) then
            self._isHu = MahjonAlgorithm.getInstance():IsHu(self._handCarde:GetCardS())
        end

        if (MahjonAlgorithm.getInstance():IsGang(self._handCarde:GetCardS(), card, 4)) then       --自己摸起来的四张就是暗杠
            self._isGang = 1
        elseif (MahjonAlgorithm.getInstance():IsGang(self._handCarde:getCardTypeList(), card, 3)) then  --碰了的三张牌自己摸起来一张就是加杠        
            self._isGang = 2
        end

        if (self._target.transform.name == "Me") then
            self:OneselfChooseCard(self._isPeng, self._isGang, self._isHu)
        else
            if (self._isGang == -1 and self._isHu == false) then        --机器人没有可听的牌的时候自动出牌
                self._handCarde:AutoOutCard()
            end
            self:RobotChooseCard(self._isPeng, self._isGang, self._isHu)
        end
    end
end

--  听别人打出的牌
function PlayerPanel:ListenOutCard( card )
    self._isPeng = false
    self._isHu = false
    self._isGang = -1
    self._isOnListenCard = true
    local gameInstance = GameManager.getInstance()

    if (self._handCarde:getCurrentFlowerPig() ~= card:getCardMark()) then
        self._tempOutCard = card
        self._isSelfTouch = false
        self._isPeng = MahjonAlgorithm.getInstance():IsPeng(self._handCarde:GetCardS(), card)

        if (MahjonAlgorithm.getInstance():IsGang(self._handCarde:GetCardS(), card, 3)) then
            self._isGang = 0
        end

        if (self._handCarde:GetCurrentFlowerPigCount() == 0) then
            local headCards = self._handCarde:GetCardS()
            table.insert(headCards,card)
            self._isHu = MahjonAlgorithm.getInstance():IsHu(headCards)
        end
    end

    if (self._isPeng == false and self._isGang == -1 and self._isHu == false) then
        self._isOnListenCard = false
        return
    end

    if (self._target.transform.name == "Me") then
        self:OneselfChooseCard(self._isPeng, self._isGang, self._isHu)
    else
        self:RobotChooseCard(self._isPeng, self._isGang, self._isHu)
    end
end

function PlayerPanel:OneselfChooseCard(isPeng, isGang, isHu)
    if (isPeng) then     --是否可以碰牌    
        self._listenCard:getPengButton().gameObject:SetActive(true)
        self._listenCard:getGuoButton().gameObject:SetActive(true)
    end

    if (isGang >= 0) then  --是否可以杠牌 -1不能 0是明杠 1加杠 2是暗杠
        self._listenCard:getGangButton().gameObject:SetActive(true)
        self._listenCard:getGuoButton().gameObject:SetActive(true)
    end

    if (isHu) then      --是否可以胡牌
        self._listenCard:getHuButton().gameObject:SetActive(true)
        self._listenCard:getGuoButton().gameObject:SetActive(true)
    end
end 


function PlayerPanel:RobotChooseCard( isPeng, isGang, isHu )
    if (isHu) then              --是否可以胡牌
        self:HuCard()
    elseif (isGang >= 0) then   --是否可以杠牌 -1不能 0是明杠 1加杠 2是暗杠
        self:GangCard()
    elseif (isPeng) then        --是否可以碰牌
        self:PengCard()
    end
end

function PlayerPanel:PengCard()
    GameAudio.getInstance():PlayaudioSourceAuto("man_peng0", CS.UnityEngine.Camera.main.transform.position)
    self._handCarde:AddToHandCard(self._tempOutCard, self._tempOutCard:getImageName())
    self._handCarde:MoveToCardTypeList(self._tempOutCard, 3)
    self._handCarde:setIsNoGetCard(true)
    local gameInstance = GameManager.getInstance()
    gameInstance:DisappearNewOutCardS()               --让服务器删掉刚出的牌
    gameInstance:SetCurrentOutCardIndex(self._myPosIndex)   --让服务器下一次让自己出牌
    self._isOnListenCard = false
end


function PlayerPanel:GangCard()
    local gameInstance = GameManager.getInstance()
    GameAudio.getInstance():PlayaudioSourceAuto("man_gang1", CS.UnityEngine.main.transform.position)
    gameInstance:SetCurrentOutCardIndex(self._myPosIndex)      --让服务器下一次让自己出牌

    --0是明杠，1是暗杠，2是加杠
    if (self._isGang == 0) then
        self._handCarde:AddToHandCard(self._tempOutCard, self._tempOutCard:getImageName())
        self._handCarde:MoveToCardTypeList(self._tempOutCard, 4)
        gameInstance:DisappearNewOutCardS()         --让服务器删掉刚出的牌
        self._isOnListenCard = false
    elseif (self._isGang == 1) then
        self._handCarde:MoveToCardTypeList(self._tempOutCard, 4)
        gameInstance:TabCurrentOutCard()            --自摸的杠需要通知服务器切牌
    elseif (self._isGang == 2) then
        self._handCarde:MoveToCardTypeList(self._tempOutCard, 1)
        gameInstance:TabCurrentOutCard()            --自摸的杠需要通知服务器切牌
    end
end


function PlayerPanel:HuCard()
    self._isHuCard = true
    GameAudio.getInstance():PlayaudioSourceAuto("man_hu0", CS.UnityEngine.Camera.main.transform.position)
    print(self._target.transform.name .. " 胡牌了 不打了")
    if (self._isSelfTouch) then
        GameManager.getInstance():TabCurrentOutCard()             --直接需要通知服务器切牌
    else
        self._isOnListenCard = false
    end
end


function PlayerPanel:GuoCard()
    GameAudio.getInstance():PlayaudioSourceRole("ui_click")
    self._isOnListenCard = false
end


function PlayerPanel:EndListenCardButton()
    if(not self._listenCard) then
        self._listenCard:getPengButton().gameObject:SetActive(false)
        self._listenCard:getGangButton().gameObject:SetActive(false)
        self._listenCard:getHuButton().gameObject:SetActive(false)
        self._listenCard:getGuoButton().gameObject:SetActive(false)
    end
end

function PlayerPanel:GetFlowerPi()
    self._isOnChooseFlowerPig = true
    if (self._target.transform.name == "Me") then
        -- self._chooseFP.gameObject:SetActive(true)
        self._target.transform:Find("ChooseFlowerPigPanel").gameObject:SetActive(true)
        -- StartCoroutine(EndFlowerPigButton())
        util.coroutine_call(EndFlowerPigButton)
    else
        --自动选择一个花猪
        self:SetFlowerPig(self._handCarde:AutoChooseFlowerPig())
    end
end

function PlayerPanel:EndFlowerPigButton( ... )
    local yield_return = UtilTools.yield_return
    yield_return(CS.UnityEngine.WaitForSeconds(5.5))
    if (self._isOnChooseFlowerPig) then
        --自动选择一个花猪
        -- ChooseFP.gameObject.SetActive(false);
        self._target.transform:Find("ChooseFlowerPigPanel"):SetActive(false)
        self:SetFlowerPig(self._handCarde:AutoChooseFlowerPig())
    end
end 

function PlayerPanel:SetFlowerPig(str)
    self._handCarde:setCurrentFlowerPig(str)
    self._infoFlowerPigImage.sprite = CS.UnityEngine.Resources.Load("UIs/" .. str,typeof(CS.UnityEngine.Sprite))
    self._infoFlowerPigImage.enabled = true
    self._isOnChooseFlowerPig = false
end

-- target:ME,Next,Across,Last 四个控件中的某一个
function PlayerPanel:Awake( target )
    self._posText = target.transform:Find("Pos"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    -- HandCardList控件的脚本
    self._handCarde = HandCardList.new()
    self._handCarde:create(target.transform:Find("HandCardList"))
    -- AwaitCardList控件的脚本
    self._awaitCard = AwaitCardList.new()
    self._awaitCard:create(target.transform:Find("AwaitCardList"))

    if (target.transform.name == "Me") then
        local obj = target.transform:Find("ChooseFlowerPigPanel")
        self._chooseFP = ChooseFlowerPig.new()
        self._chooseFP:create(obj)
        -- ListenCardList控件的脚本
        self._listenCard = ListenCardList.new()
        self._listenCard:create(target.transform:Find("ListenCardList"))
    end
    self._infoHeadImage = target.transform:Find("InfoPanel/Head"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self._infoDealerImage = target.transform:Find("InfoPanel/Dealer"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self._infoFlowerPigImage = target.transform:Find("InfoPanel/FlowerPig"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self._infoNameText = target.transform:Find("InfoPanel/Name"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self._infoGoldText = target.transform:Find("InfoPanel/Gold/Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
end

--PlayerPanel 对应的控件名字
function PlayerPanel:getTargetName( ... )
   return self._target.transform.name
end

function PlayerPanel:create( target )
    self._target = target
    self:Awake(target)
end

