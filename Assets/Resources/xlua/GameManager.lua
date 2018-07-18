-- FileName: 
-- Author:qiaoba
-- Date:2018-05-17 17:01:41
-- Purpose: 文件描述，请修改

GameManager = class("GameManager")

local _gameManagerInstance = nil 

local util = require 'xlua.util'

GameManager.getInstance = function ( ... )
	if (_gameManagerInstance == nil) then 
		_gameManagerInstance = GameManager.new()
		_gameManagerInstance:create()
	end 
	return _gameManagerInstance
end


function GameManager:getCards( ... )
	return self._cards
end

function GameManager:setCards( value )
	self._cards = value
end

function GameManager:update( ... )
	if(self._newOutPoint) then
		print("----------------GameManager.update")
		if (not self._biaojiPoint) then
			self._biaojiPoint = self._curCanvas.transform:Find("Biaoji")
			print("----------------GameManager.update self._biaojiPoint=",self._biaojiPoint)
		end
		self._biaojiPoint.gameObject:SetActive(true)
		self._biaojiPoint.position = CS.UnityEngine.Vector3(self._newOutPoint.position.x, self._newOutPoint.position.y + 30, self._newOutPoint.position.z)
	end
	-- 调用骰子的更新
	Touzi.getInstance(...):Update()
end

function GameManager:StartMatch( ... )
	GameAudio.getInstance():PlayaudioSourceUI("start_game")

	local coroutine_func = util.coroutine_call(function ( ... )
		self:InitMatch()
	end)
	coroutine_func()
end


function GameManager:onStartBtn( ... )
	--有坑备注
	--UnityEngine.UI.Button 和GameObject都继承自Object，但Button不继承GameObject.
	--SetActive是GameObject中的接口，Button没有这个接口，所以不能直接让startBtn执行SetActive
	local gameObject = CS.UnityEngine.GameObject.Find("StartButton")
	local startBtn = gameObject:GetComponent("Button")
	startBtn.onClick:AddListener(function ()
		self:StartMatch()
		gameObject:SetActive(false)
	end)
end

function GameManager:InitCards()
	self._w = {"mingmah_1","mingmah_2","mingmah_3","mingmah_4","mingmah_5",
		"mingmah_6","mingmah_7","mingmah_8","mingmah_9"}
	
	self._ti = {"mingmah_11","mingmah_12","mingmah_13","mingmah_14","mingmah_15",
		"mingmah_16","mingmah_17","mingmah_18","mingmah_19"}

	self._to = {"mingmah_21","mingmah_22","mingmah_23","mingmah_24","mingmah_25",
		"mingmah_26","mingmah_27","mingmah_28","mingmah_29"}

	self._soundwan = { "man11", "man12", "man13", "man14","man15","man16", "man17", "man18", "man19" }

	self._soundtiao = { "man21", "man22", "man23", "man24","man25","man26", "man27", "man28", "man29" }

	self._soundtong = { "man31", "man32", "man33", "man34","man35","man36", "man37", "man38", "man39" }

	self:AddCard(self._w, self._soundwan)
	self:AddCard(self._ti, self._soundtiao)
	self:AddCard(self._to, self._soundtong)
end

-- tbImages：原为string []，替换成table
-- tbSounds：原为string []，替换成table
function GameManager:AddCard(tbImages, tbSounds)
	--依次添加万子,条子,筒子
	for i=1, 4 do
		for j=1, #tbImages do
			local myCard = nil
			if (tbImages == self._w) then
				myCard = Card.new()
				local name = j .. "万"
				myCard:create(name, j, "万", tbImages[j], tbSounds[j])
			elseif (tbImages == self._ti) then
				myCard = Card.new()
				local name = j .. "条"
				myCard:create(name, j, "条", tbImages[j], tbSounds[j])
			elseif(tbImages == self._to) then
				myCard = Card.new()
				local name = j .. "筒"
				myCard:create(name, j, "筒", tbImages[j], tbSounds[j])
			end
			table.insert(self._cards,myCard)
		end
	end
end


function GameManager:SetSeat()
	--这里我是单机所以直接可以生成
	-- 1=东，2=南，3=西。4=北  0是我 1是下家 2 是对家 3是上家
	local pos = math.random(1, 4)
	if (pos == 1) then
		self._players[1]:getPosText().text = "东"
		self._players[1]:setMyPosIndex(1)
		self._players[2]:getPosText().text = "南"
		self._players[2]:setMyPosIndex(2)
		self._players[3]:getPosText().text = "西"
		self._players[3]:setMyPosIndex(3)
		self._players[4]:getPosText().text = "北"
		self._players[4]:setMyPosIndex(4)
	elseif (pos == 2) then
		self._players[1]:getPosText().text = "南"
		self._players[1]:setMyPosIndex(2)
		self._players[2]:getPosText().text = "西"
		self._players[2]:setMyPosIndex(3)
		self._players[3]:getPosText().text = "北"
		self._players[3]:setMyPosIndex(4)
		self._players[4]:getPosText().text = "东"
		self._players[4]:setMyPosIndex(1)
	elseif (pos == 3) then
		self._players[1]:getPosText().text = "西"
		self._players[1]:setMyPosIndex(3)
		self._players[2]:getPosText().text = "北"
		self._players[2]:setMyPosIndex(4)
		self._players[3]:getPosText().text = "东"
		self._players[3]:setMyPosIndex(1)
		self._players[4]:getPosText().text = "南"
		self._players[4]:setMyPosIndex(2)
	elseif (pos == 4) then
		self._players[1]:getPosText().text = "北"
		self._players[1]:setMyPosIndex(4)
		self._players[2]:getPosText().text = "东"
		self._players[2]:setMyPosIndex(1)
		self._players[3]:getPosText().text = "南"
		self._players[3]:setMyPosIndex(2)
		self._players[4]:getPosText().text = "西"
		self._players[4]:setMyPosIndex(3)
	end
end

--我们在这里用本地模式随机获得庄家
-- 1=东，2=南，3=西。4=北
function GameManager:SetDealer()
	self._dealer = math.random(1, 4)
end

-- 获取当前的庄家并播放骰子动画
function GameManager:SetHitPoint()
	--通过摇骰子设置拿牌位置
	local touziOne = math.random(1, 6)
	local touziTwo = math.random(1, 6)
	Touzi.getInstance():getTouziOne():setLastImage(CS.UnityEngine.Resources.Load("UIs/Touzi/touzi" .. touziOne, typeof(CS.UnityEngine.Sprite))) 
	Touzi.getInstance():getTouziTwo():setLastImage(CS.UnityEngine.Resources.Load("UIs/Touzi/touzi" .. touziTwo, typeof(CS.UnityEngine.Sprite)))
	GameAudio.getInstance():PlayaudioSourceRole("touzi")
	Touzi.getInstance():PlayerAllAnimation()

	--先找到庄家然后从庄家开始循环骰子点 结束后在获得在谁玩家手上拿牌
	local who = 0
	for i = 1, #self._players do
		if (self._dealer == self._players[i]:getMyPosIndex()) then
			who = i + 1
			for j = 1, touziOne + touziTwo do
				who = who - 1
				if (who <= 0) then
					who = 4
				end
			end
			break
		end
	end

	self._inWhoGetCard = who
	if(touziOne > touziTwo) then
		self._inWhoGetCardIndex = touziTwo
	else
		self._inWhoGetCardIndex = touziOne
	end
end

function GameManager:CardDesktopShow()
	self._players[1]:getAwaitCard():AddCardInTable("mingmah_2", self._players[1]:getMyPosIndex())
	self._players[2]:getAwaitCard():AddCardInTable("mingmah_1", self._players[2]:getMyPosIndex())
	self._players[3]:getAwaitCard():AddCardInTable("mingmah_2", self._players[3]:getMyPosIndex())
	self._players[4]:getAwaitCard():AddCardInTable("mingmah_1", self._players[4]:getMyPosIndex())
end

function GameManager:CardDesktopShowOff()
	--摸牌应该逆时针摸
	for i = 1, #self._players do
		local indexDownList = self._players[self._inWhoGetCard]:getAwaitCard():getIndexDownList()
		if (self._inWhoGetCardIndex > #indexDownList) then
			self._inWhoGetCard = self._inWhoGetCard - 1
			if(self._inWhoGetCard <= 0) then
				self._inWhoGetCard = 4
			end
			self._inWhoGetCardIndex = 1
		end

		local up = self._players[self._inWhoGetCard]:getAwaitCard():getIndexUpList()[self._inWhoGetCardIndex].enabled
		local down = self._players[self._inWhoGetCard]:getAwaitCard():getIndexDownList()[self._inWhoGetCardIndex].enabled
		
		if (up == true) then
			self._players[self._inWhoGetCard]:getAwaitCard():getIndexUpList()[self._inWhoGetCardIndex].enabled = false
			return true
		elseif (down == true) then
			self._players[self._inWhoGetCard]:getAwaitCard():getIndexDownList()[self._inWhoGetCardIndex].enabled = false
			return true
		end

		self._inWhoGetCardIndex = self._inWhoGetCardIndex + 1
	end
	return false
end


function GameManager:InitPlayersData()
	--如果联网的话 其实我们只需要设置自己的牌就行了 你的对手直接显示手牌界面就行了
	--生成设置全部玩家的牌
	local cout = 0
	local zhuang = 1
	for i=1, #self._players do
		cout = 13
		if (self._dealer == self._players[i]:getMyPosIndex()) then
			zhuang = i
			cout = 14
		end
		for j = 0, cout do
			self:AssignCard(self._players[i])
		end
	end

	--第一次庄家不摸牌
	self._currentOutCardIndex = self._players[zhuang]:getMyPosIndex()
	self._players[zhuang]:getInfoDealerImage().enabled = true
	self._players[zhuang]:getHandCarde():setIsNoGetCard(true)

	return zhuang
end


-- player:PlayerPanel
-- return:Card
function GameManager:AssignCard(player)
	if (#self._cards > 0) then
		local number = math.random(1,#self._cards)
		local card = self._cards[number]

		if (player:getTargetName() == "Me") then
			player:getHandCarde():AddToHandCard(card, card:getImageName())
		elseif (player:getTargetName() == "Next") then
			player:getHandCarde():AddToHandCard(card, "hand_right")
		elseif (player:getTargetName() == "Across") then
			player:getHandCarde():AddToHandCard(card, "hand_top")
		elseif (player:getTargetName() == "Last") then
			player:getHandCarde():AddToHandCard(card, "hand_left")
		end

		self:CardDesktopShowOff()
		table.remove(self._cards, number)
		return card
	else
		return nil
	end
end

-- outtPoint:Transform
function GameManager:SetBiaojiPoint(outtPoint)
	self._newOutPoint = outtPoint
end

-- who:int
function GameManager:StartTimer( who )
	--有些时候我们调用的时候不需要摸牌（碰牌的情况下）
	if (self._players[who]:getHandCarde():getIsNoGetCard()) then
		self._players[who]:getHandCarde():setIsNoGetCard(false)
		TimerPanel.getInstance():UpdateTimer(who)
		self._players[who]:getHandCarde():setIsOutCard(true)

		if (self._players[who]:getTargetName() ~= "Me") then
			--在单机模式下 其他玩家可以直接自动出牌
			self._players[who]:getHandCarde():AutoOutCard()
		end
	else
		local card = self:AssignCard(self._players[who])
		if (card) then
			TimerPanel.getInstance():UpdateTimer(who)
			self._players[who]:getHandCarde():setIsOutCard(true)
			self._players[who]:ListenTouchCard(card)
		else
			print("牌都打完了哦 牌局结束了")
			self:EndMatch()
		end
	end
end

function GameManager:OverTimer()
	--我们在这里开始检测出牌顺序和监听 1 是自己 2 是下家 3 是对家 4 是上家
	for i=1, #self._players do
		if (self._currentOutCardIndex == self._players[i]:getMyPosIndex()) then
			self._players[i]:getHandCarde():AutoOutCard()
			break
		end
	end
end


-- index:int
function GameManager:SetCurrentOutCardIndex(index)
	self._currentOutCardIndex = index - 1;
end

-- 有玩家需要刚出的牌并自己重新创建了一个所以我们服务器来判断谁刚出的那个牌并让他删掉
function GameManager:DisappearNewOutCardS()
	for i = 1, #self._players do
		if (self._players[i]:getMyPosIndex() == self._currentOutCardIndex) then
			self._players[i]:getHandCarde():DisappearNewOutCard()
			break
		end
	end
end


-- count:int
function GameManager:TabCurrentOutCard(count)
	count = count or 4
	self._currentOutCardIndex = self._currentOutCardIndex + 1
	if (self._currentOutCardIndex > 4) then
		self._currentOutCardIndex = 1
	end
	
	--我们在这里开始检测出牌顺序和监听 1 是自己 2 是下家 3 是对家 4 是上家
	local who = -1

	for i = 1, #self._players do
		if (self._currentOutCardIndex == self._players[i]:getMyPosIndex()) then
			if (not self._players[i]:getIsHuCard()) then
				if (self._players[i]:getTargetName() == "Me") then
					--隐藏我激活的按钮
					self._players[1]:EndListenCardButton()
				end
				who = i
				break
			else
				--这个玩家已经糊牌就切换下一个
				self:TabCurrentOutCard(count - 1)
			end
		end
	end

	if (who ~= -1 and count > 1) then
		self:StartTimer(who)
	else
		print("三位玩家已经胡牌 游戏结束了哦")
		self:EndMatch()
	end
end

function GameManager:EndMatch()
	CS.UnityEngine.SceneManagement.SceneManager.LoadScene("EedMatch")
end


--给其他玩家发送听牌信息
-- handCard:Card
function GameManager:StartOutNewCard(handCard)
	--隐藏我激活的按钮
	self._players[1]:EndListenCardButton()
	TimerPanel.getInstance():setIsOnTimer(false)
	GameAudio.getInstance():PlayaudioSourceUI("out_card")
	GameAudio.getInstance():PlayaudioSourceAuto(handCard:getSoundName(),CS.UnityEngine.Camera.main.transform.position)

	-- 开启协程
	local coroutine_func = util.coroutine_call(function ( ... )
		self:EndOutNewCard(handCard)
	end)

	coroutine_func()
end

-- 限制 最少1秒出牌听牌時間 7秒后强制切换牌 
-- handCard:Card
function GameManager:EndOutNewCard(handCard)
	local timeStart = os.time()
	--让服务器延迟一段时间执行
	local yield_return = UtilTools.yield_return()
	yield_return(CS.UnityEngine.WaitForSeconds(1))

	for i = 1, #self._players do
		-- 现在出牌的这个不会听牌
		if (self._players[i]:getMyPosIndex() ~= self._currentOutCardIndex and self._players[i]:getIsHuCard() == false) then
			self._players[i]:ListenOutCard(handCard)
		end
	end

	local isAllListenCard = true

	while (isAllListenCard) do
		isAllListenCard = false
		for i = 1, #self._players do
			if (self._players[i]:getIsOnListenCard() == true) then
				isAllListenCard = true
				break
			end
		end

		if(os.time() - timeStart > 6) then
			isAllListenCard = false
		end
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
	end
	self:TabCurrentOutCard()
end


-- 协程函数体
function GameManager:InitMatch()
	--设置谁是庄家
	self:SetDealer()

	--打开显示所有麻将
	self:CardDesktopShow() 

	Touzi.getInstance():TouziShow(true)
	-- 通过丢骰子设置摸牌的位置
	self:SetHitPoint()

	local yield_return = UtilTools.yield_return()
	yield_return(CS.UnityEngine.WaitForSeconds(3))
	Touzi.getInstance():TouziShow(false)

	-- 初始所有玩家的数据
	local zhuang = self:InitPlayersData()
	--给自己手上的牌排序
	self._players[1]:getHandCarde():HandCardSort() 
	local timeStart = os.time()

	for i = 1, #self._players do
	   self._players[i]:GetFlowerPi()
	end

	local isAllChooseFlowerPig = true

	while (isAllChooseFlowerPig) do
		isAllChooseFlowerPig = false
		for i = 1, #self._players do
			if (self._players[i]:getIsOnChooseFlowerPig()) then
				isAllChooseFlowerPig = true
			end
		end

		if (os.time() - timeStart > 6) then
			isAllChooseFlowerPig = false
		end
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
	end

	--给自己手上的牌排序
	self._players[1]:getHandCarde():HandCardSort()
	-- 开始计时器出牌
	self:StartTimer(zhuang)
end


function GameManager:addBtnEvent( ... )
	self:onStartBtn()
end

function GameManager:init( ... )
	self._w = {}
	self._ti = {}
	self._to = {}
	self._soundwan = {}
	self._soundtiao = {}
	self._soundtong = {}
	self._cards = {}
	-- self._cards
	self._players = {}
	self._dealer = 0
	self._inWhoGetCard = 0
	self._inWhoGetCardIndex = 0
	self._currentOutCardIndex = 0
	self._newOutPoint = nil

	self._curCanvas = CS.UnityEngine.GameObject.FindWithTag("desktopCanvas")
	self._biaojiPoint = self._curCanvas.transform:Find("Biaoji")

	--初始化四名玩家
	local player = CS.UnityEngine.GameObject.Find("Players")
	local tbNames = { "Me", "Next", "Across", "Last" }

	for k,v in pairs(tbNames) do
		local obj = player.transform:Find(v)
		local playerpanel = PlayerPanel.new()
		playerpanel:create(obj)
		self._players[k] = playerpanel
	end
end

function GameManager:Start( ... )
	self:InitCards()
	self:SetSeat()
end

function GameManager:create( ... )
	self:init()
	self:addBtnEvent()
	self:Start()
	local gameAudio = GameAudio.getInstance()
	gameAudio:PlayaudioSourceBG("backMusic01")
end

