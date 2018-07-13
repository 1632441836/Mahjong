-- FileName: 
-- Author:yangna
-- Date:2018-05-24 16:25:59
-- Purpose: 文件描述，请修改


HandCardList = class("HandCardList")

function HandCardList:ctor()
    -- List和dict全部用lua的table代替
    -- private List<HandCard> wanCardList = new List<HandCard>();
    -- private List<HandCard> tiaoCardList = new List<HandCard>();
    -- private List<HandCard> tongCardList = new List<HandCard>();
    -- private List<HandCard> _outCardList = new List<HandCard>();
    -- private List<Card> _cardTypeList=new List<Card>();
    -- private List<Transform> cardTypePoint = new List<Transform>();
    
    -- private Dictionary<string, Transform> cardTPD=new Dictionary<string, Transform>();
    -- private Dictionary<string,Sprite> headCSD=new Dictionary<string, Sprite>();
    -- private Dictionary<string, Sprite> outCSD = new Dictionary<string, Sprite>();

    -- private GameObject currentObj = null;
    -- private HandCard newAddHC;
    -- private HandCard newOutHC;
    -- private Transform newAddPoint;
    -- private Transform gridListPoint;
    -- private Transform outGridListPoint;
    -- private Vector3 movePos;
    -- private string _currentFlowerPig="";
    -- private bool _isOutCard = false;
    -- private bool _isNoGetCard = false;
    -- public HandCard handCard;
    -- self._wanCardList = CS.List("HandCard")


    self._target = nil
    self._wanCardList = {}
    self._tiaoCardList = {}
    self._tongCardList = {}
    self._outCardList = {}
    self._cardTypeList = {}
    self._cardTypePoint = {}
    self._cardTPD = {}
    self._headCSD = {}
    self._outCSD = {}

    self._currentObj = nil
    self._newAddHC = nil
    self._newOutHC = nil
    self._newAddPoint = nil
    self._gridListPoint = nil
    self._outGridListPoint = nil
    self._movePos = nil
    self._currentFlowerPig = ""
    self._isOutCard = false
    self._isNoGetCard = false
end


function HandCardList:setIsOutCard(value)
	self._isOutCard = value
end

function HandCardList:getIsOutCard()
	return self._isOutCard
end

function HandCardList:setOutCardList(value)
	self._outCardList = value
end

function HandCardList:getOutCardList()
	return self._outCardList
end

function HandCardList:setCardTypeList(value)
	self._cardTypeList = value
end

function HandCardList:getCardTypeList()
	return self._cardTypeList
end

function HandCardList:setIsNoGetCard(value)
	self._isNoGetCard = value
end

function HandCardList:getIsNoGetCard()
	return self._isNoGetCard
end

function HandCardList:setCurrentFlowerPig(value)
	self._currentFlowerPig = value
end

function HandCardList:getCurrentFlowerPig()
	return self._currentFlowerPig
end


function HandCardList:Awake()
    self._movePos = CS.UnityEngine.Vector3(0, 20, 0)
    self._gridListPoint = self._target:Find("GridList"):GetComponent(typeof(CS.UnityEngine.Transform))
    self._outGridListPoint = self._target:Find("OutGridList"):GetComponent(typeof(CS.UnityEngine.Transform))
    local tfArray = self._target:Find("CardTypeList/Grid"):GetComponentsInChildren(typeof(CS.UnityEngine.Transform))

    -- tfArray是C#的数组
    for i=0,tfArray.Length-1 do
        table.insert(self._cardTypePoint,tfArray[i])
    end

    if (self._target.transform.parent.name == "Me") then
        self._newAddPoint = self._target.transform:Find("NewAdd"):GetComponent(typeof(CS.UnityEngine.Transform))
    end
end

function HandCardList:Start()
    self:AddSpriteToArray()
end

function HandCardList:AddSpriteToArray()
    local headCardPath = ""
    local outCardPath = ""
    local tsname = self._target.transform.parent.name

    if (tsname == "Me") then
        headCardPath = "MeHeadCard"
        outCardPath = "DownOutCard"
    elseif (tsname == "Next") then
        headCardPath = "OtherHeadCard"
        outCardPath = "RightOutCard"
    elseif (tsname == "Across") then
        headCardPath = "OtherHeadCard"
        outCardPath = "MeHeadCard"     --把我手中显示的牌旋转180°就是对面出牌的显示效果
    elseif (tsname == "Last") then
        headCardPath = "OtherHeadCard"
        outCardPath = "LeftOutCard"
    end

    -- Sprite[] spArray;
    local spArray    
    spArray = CS.UnityEngine.Resources.LoadAll("UIs/Card/" .. headCardPath,typeof(CS.UnityEngine.Sprite))
    for i=0,spArray.Length-1 do
        local sp = spArray[i]
        self._headCSD[sp.name] = sp
    end

    spArray = CS.UnityEngine.Resources.LoadAll("UIs/Card/" .. outCardPath,typeof(CS.UnityEngine.Sprite))
    for i=0,spArray.Length-1 do
        local sp = spArray[i]
        self._outCSD[sp.name] = sp
    end
end



-- card:Card对象
-- imangName：string
function HandCardList:AddToHandCard( card, imangName )
    -- HandCard hc = Canvas.Instantiate(self._handCard)
    -- hc_object是加载的perfab，hc模拟绑定在上面的HandCard脚本控件
    print("------------------HandCardList:AddToHandCard-1")
    local hc_object = CS.UnityEngine.Canvas.Instantiate(self._handCard)
    local hc = HandCard.new()
    hc:create(hc_object)

    print("------------------HandCardList:AddToHandCard-2")
    if (hc ~= nil) then
        local sp = nil
        hc:setCard(card)
        sp = self._headCSD[imangName]
        hc:getHandCardImage().sprite = sp
        print("------------------HandCardList:AddToHandCard-3")
        if(self._currentFlowerPig == card:getCardMark() and self._target.transform.parent.name == "Me") then
            self:SetGreyCard(hc)
        elseif (card:getCardMark() == "万") then
            table.insert(self._wanCardList,hc)
            self:MarksCardSort(self._wanCardList)
        elseif (card:getCardMark() == "条") then
            table.insert(self._tiaoCardList,hc)
            self:MarksCardSort(self._tiaoCardList)
        elseif (card:getCardMark() == "筒") then
            table.insert(self._tongCardList,hc)
            self:MarksCardSort(self._tongCardList)
        end
        print("------------------HandCardList:AddToHandCard-4")
        if(self._newAddPoint ~= nil) then
            self._newAddHC = hc
            hc:getTarget().transform.parent = self._newAddPoint.transform
            hc:getTarget().transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
            self._newAddPoint.transform.localPosition = CS.UnityEngine.Vector3(self:GetHeadCardCount() * 35, 0, 0)
        else
            hc:getTarget().transform.parent = self._gridListPoint
            hc:getTarget().transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
        end
        print("------------------HandCardList:AddToHandCard-5")
        return true
    end
    return false
end


-- return table
function HandCardList:GetCardS()
    print("----------HandCardList:GetCards,allcard 11")

    local allcard = {}

    for k,hc in pairs(self._wanCardList) do 
        allcard[#allcard+1] = hc:getCard()
    end

    for k,hc in pairs(self._tiaoCardList) do 
        allcard[#allcard+1] = hc:getCard()
    end

    for k,hc in pairs(self._tongCardList) do 
        allcard[#allcard+1] = hc:getCard()
    end
    
    print("----------HandCardList:GetCards,allcard=")
    return allcard
end


function HandCardList:GetHeadCardS()
    local allHC = {}
    for k,hc in pairs(self._wanCardList) do
        allHC[#allHC+1] = hc
    end

    for k,hc in pairs(self._tiaoCardList) do
        allHC[#allHC+1] = hc
    end

    for k,hc in pairs(self._tongCardList) do
        allHC[#allHC+1] = hc
    end
    return allHC
end



-- 牌列表中，内容为CurrentFlowerPig的数量
function HandCardList:GetCurrentFlowerPigCount()
    -- List<Card> card = GetCardS();
    -- var query = card.Where(c => c.CardMark == CurrentFlowerPig);
    -- return query.ToList().Count;
    local card = self:GetCardS()
    local count = 0
    for k,v in pairs(card) do
        if (v:getCardMark() == self._currentFlowerPig) then
            count = count + 1
        end
    end
    return count
end

function HandCardList:GetHeadCardCount()
    return #self._tongCardList + #self._wanCardList + #self._tiaoCardList
end


-- card:Card类型
function HandCardList:AddToOutCardList(card)
    -- HandCard hc = Canvas.Instantiate(self._handCard)
    local hc_object = CS.UnityEngine.Canvas.Instantiate(self._handCard)
    local hc = HandCard.new()
    hc:create(hc_object)

    if (hc ~= null) then
        -- Sprite sp
        local sp = nil
        self._newOutHC = hc
        hc:setCard(card)
        sp = self._outCSD[card:getImageName()]
        hc:getHandCardImage().sprite = sp
        hc:getTarget().transform.parent = self._outGridListPoint
        hc:InitLocation()
        table.insert(self._outCardList,hc)
        GameManager.getInstance():SetBiaojiPoint(hc.transform)
    end
end


-- 把桌面或手上的牌移动到牌型表展示
-- card:Card类型
-- count：int
function HandCardList:MoveToCardTypeList(card, count)
    -- HandCard hc = null 
    -- Sprite sp;
    -- outCSD.TryGetValue(card.ImageName, out sp);
    local hc = nil
    local sp = nil
    sp = self._outCSD[card:getImageName()]

    for i=1,count do                --获取到这张牌的hc属性
        if (card:getCardMark() == "万") then
            hc = self:CardToHandCard(self._wanCardList, card)
            self:tableRemove(self._wanCardList,hc)
        elseif (card:getCardMark() == "条") then
            hc = self:CardToHandCard(self._tiaoCardList, card)
            self:tableRemove(self._tiaoCardList,hc)
        elseif (card:getCardMark() == "筒") then
            hc = self:CardToHandCard(self._tongCardList, card)
            self:tableRemove(self._tongCardList,hc)
        end

        if (count==1) then
            -- Transform ts
            local ts = nil
            ts = self._cardTPD[card:getName()]
            hc:getHandCardImage().sprite = sp
            hc:getTarget().transform.parent = ts
            hc:InitLocation()
            table.insert(self._cardTypeList,hc:getCard()) 
        elseif (count == 3 or count == 4) then
            hc:getHandCardImage().sprite = sp
            hc:getTarget().transform.parent = self._cardTypePoint[1]
            hc:InitLocation()
            if (not self._cardTPD[card:getName()]) then
                self._cardTPD[card:getName()] = self._cardTypePoint[1]
            end
            table.insert(self._cardTypeList,hc:getCard())  
        end
    end

    if (count ~= 1) then
        table.remove(self._cardTypePoint,1)
    end

    self:HandCardSort()
end

function HandCardList:AutoChooseFlowerPig()
    if (#self._wanCardList <= #self._tiaoCardList and #self._wanCardList <= #self._tongCardList) then
        return "万"
    elseif (#self._tiaoCardList <= #self._wanCardList and #self._tiaoCardList <= #self._tongCardList) then
        return "条"
    elseif (#self._tongCardList <= #self._wanCardList and #self._tongCardList <= #self._tiaoCardList) then
        return "筒"
    end
    return ""
end

function HandCardList:AutoOutCard()
    -- Card card= MahjonAlgorithm.getInstance():GoCard(GetCardS(),CurrentFlowerPig)
    -- HandCard hc = null
    print("--------------HandCardList_AutoOutCard_1")

    local card = MahjonAlgorithm.getInstance():GoCard(self:GetCardS(),self._currentFlowerPig)
    print("--------------HandCardList_AutoOutCard_2")

    local hc = nil
    print("--------------HandCardList_AutoOutCard_3,card:getCardMark()=",card:getCardMark())
    if (card:getCardMark() == "万") then
        hc = self:CardToHandCard(self._wanCardList, card)
    elseif (card:getCardMark() == "条") then
        hc = self:CardToHandCard(self._tiaoCardList, card)
    elseif (card:getCardMark() == "筒") then
        hc = self:CardToHandCard(self._tongCardList, card)
    end
    self:RemoveHandCard(hc)
end

-- 给自己的牌排序
function HandCardList:HandCardSort()
    -- Dictionary<string, List<HandCard>> dicList=new Dictionary<string, List<HandCard>>();
    -- dictList是一个key-value型table,每个value是一个table
    local dicList = {}
    if (self._currentFlowerPig == "万") then
        dicList["条"] = self._tiaoCardList
        dicList["筒"] = self._tongCardList
        dicList["万"] = self._wanCardList
    elseif (self._currentFlowerPig == "条") then
        dicList["万"] = self._wanCardList
        dicList["筒"] = self._tongCardList
        dicList["条"] = self._tiaoCardList
    else
        dicList["万"] = self._wanCardList
        dicList["条"] = self._tiaoCardList
        dicList["筒"] = self._tongCardList
    end
   
    self:MarksHandCardSort(dicList)
end

-- list:原本是List<HandCard>类型，这里是个table
function HandCardList:MarksCardSort(list)
    for i=1,#list do
        -- HandCard min = list[i]
        local min = list[i]
        local minIndex = i            --最小的值所在索引
        for j= i + 1, #list-1 do
            if (list[j]:getCard():getSize() < min:getCard():getSize()) then
                min = list[j]
                minIndex = j
            end
        end
        if (minIndex ~= i) then
            -- HandCard temp = list[i]
            local temp = list[i]
            list[i] = list[minIndex]
            list[minIndex] = temp
        end
    end
end

-- list: 对应 List<HandCard> 类型
-- card: Card 类型
function HandCardList:CardToHandCard(list, card)
    for k,hc in pairs(list) do
        if (hc:getCard():getSize() == card:getSize()) then
            return hc
        end
    end
    return nil
end

-- param=Dictionary<string, List<HandCard>> dicList
-- 把dictList替换成了key-value类型的table，每个value也是一个table
function HandCardList:MarksHandCardSort(dicList)
    -- int number = 0;
    -- foreach (var list in dicList)
    -- {
    --     for (int i = 0; i < list.Value.Count; i++)
    --     {
    --         number++;
    --         if (list.Value[i].transform.parent.name != "GridList")
    --         {
    --             list.Value[i].transform.parent = gridListPoint;
    --         }
    --         if (list.Key==CurrentFlowerPig && transform.parent.name=="Me")
    --         {
    --             SetGreyCard(list.Value[i]);
    --         }
    --         list.Value[i].transform.SetSiblingIndex(number);
    --     }
    -- }
    local number = 0
    for k,list in pairs(dicList) do
        for i=1,#list do
            number = number + 1
            if (list[i]:getTarget().transform.parent.name ~= "GridList") then 
                list[i]:getTarget().transform.parent = self._gridListPoint
            end
            if (k == self._currentFlowerPig and self._target.parent.name == "Me") then
                self:SetGreyCard(list[i])
            end
            list[i]:getTarget().transform:SetSiblingIndex(number)
        end
    end
end

-- hc:HandCard类型
function HandCardList:SetGreyCard(hc)
    hc:getHandCardImage().color = CS.UnityEngine.Color.gray
end

function HandCardList:DisappearNewOutCard()
    self._newOutHC:getHandCardImage().color = CS.UnityEngine.Color.gray
end

-- hc:HandCard类型
function HandCardList:RemoveHandCard(hc)
    print("-------------------HandCardList:RemoveHandCard 1")
    self._isOutCard = false
    local str = "" .. self._target.transform.parent.name .. "打出去的牌是："
    local name = hc:getCard():getName()

    if (self:tableRemove(self._wanCardList,hc)) then
        print(str .. hc:getCard():getName())
    elseif (self:tableRemove(self._tiaoCardList,hc)) then
        print(str .. hc:getCard():getName())
    elseif (self:tableRemove(self._tongCardList,hc)) then
        print(str .. hc:getCard():getName())
    end
    
    --把手上的牌移动到出牌列表中并更改显示图片
    self:AddToOutCardList(hc:getCard())
    CS.UnityEngine.GameObject.Destroy(hc.gameObject)
    self:HandCardSort()
    print("-------------------HandCardList:RemoveHandCard 2")
    GameManager.getInstance():StartOutNewCard(self._newOutHC:getCard())
end

-- void IPointerClickHandler.OnPointerClick(PointerEventData eventData)
-- {
--     if (transform.parent.name != "Me") return;
--     GameAudio.instance.PlayaudioSourceRole("select");
--     GameObject selectObj = eventData.pointerEnter.gameObject.transform .parent.gameObject;
--     string objName = selectObj.transform.parent.name;
   
--     if (objName != "GridList" && objName != "NewAdd") return;

--     if (selectObj == null) return;

--     if (currentObj == null)
--     {
--         selectObj.transform.localPosition += movePos;
--         currentObj = selectObj;
--     }
--     elseif (currentObj.Equals(selectObj) == false)
--     {
--         currentObj.transform.localPosition -= movePos;
--         selectObj.transform.localPosition += movePos;
--         currentObj = selectObj;
--     }
--     elseif(IsOutCard)//这种情况就是现在点击的和上次点击相同的那么我们就可以直接出牌出去
--     {
--         HandCard hc = currentObj.GetComponent<HandCard>();
--         if(hc!=null)
--         {
--             currentObj = null;
--             RemoveHandCard(hc);
--         }
--     }
-- }

-- 绑定IPointerClickHandler事件
function HandCardList:OnPointerClick( ... )
    -- local pcHander = new CS.UnityEngine.IPointerClickHandler()
    -- pcHander.OnPointerClick = function (pointerEventData)
    --     print("================OnPointerClick");

    -- end
    -- self._target:addComponent(pcHander)
end


function HandCardList:tableRemove( tbData,value )
    local ret = false
    for k,v in pairs(tbData) do 
        if (v == value) then
            table.remove(tbData,k)
            ret = true
            break
        end
    end
    return ret
end

function HandCardList:create( target )
    self._target = target
    -- handCard是一个prefab，加载时需要传递什么类型？？？
    self._handCard = CS.UnityEngine.Resources.Load("Prefabs/HandCard",typeof(CS.UnityEngine.GameObject))
    self:Awake()
    self:Start()
end



