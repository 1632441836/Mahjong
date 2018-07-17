-- FileName: 
-- Author:qiaoba
-- Date:2018-05-24 10:54:24
-- Purpose: 文件描述，请修改


AwaitCardList = class("AwaitCardList")

function AwaitCardList:ctor()
    -- private GridLayoutGroup cardGridUP;
    -- private GridLayoutGroup cardGridDown;
    -- //防止作弊 只需要设置索引不赋值引用
    -- private List<Image> _indexUpList = new List<Image>();
    -- private List<Image> _indexDownList = new List<Image>();
    -- public Image cardImage;
    self._target = nil   --目标控件
    self._cardGridUP = nil
    self._cardGridDown = nil
    self._indexUpList = {}
    self._indexDownList = {}

end

function AwaitCardList:setIndexUpList(value)
	self._indexUpList = value
end

function AwaitCardList:getIndexUpList()
    return self._indexUpList
end

function AwaitCardList:setIndexDownList(value)
	self._indexDownList = value
end

function AwaitCardList:getIndexDownList()
	return self._indexDownList
end

function AwaitCardList:AddCardInTable(strImageName,index)
    -- 加载prefabs
    if (not self._cardImage) then
        self._cardImage = CS.UnityEngine.Resources.Load("Prefabs/Card",typeof(CS.UnityEngine.UI.Image))
    end
    
    local sp = CS.UnityEngine.Resources.Load("UIs/Card/" .. strImageName, typeof(CS.UnityEngine.Sprite))
	local number = 13
    --后期还需要判断不同的模式在设置牌组
    if (index == 1) then
        number = 13
    elseif (index == 2) then
        number = 14
    elseif (index == 3) then
        number = 13
    elseif (index == 4) then
        number = 14
    end
    
    for i=0,number-1 do
        local im = nil
        self._cardImage.sprite = sp
        im = CS.UnityEngine.Canvas.Instantiate(self._cardImage, self._cardGridUP.transform)
        im.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
        if (im ~= null) then
            im.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
            table.insert(self._indexUpList,im)
        end
        im = CS.UnityEngine.Canvas.Instantiate(self._cardImage, self._cardGridDown.transform)
        im.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
        if (im ~= null) then
            table.insert(self._indexDownList,im)
        end
    end

    --如果是最后一位玩家就让他列表倒序拿牌显示
    if(self._target.transform.parent.name == "Last") then
        self._indexUpList = self:ListReverseOrder(self._indexUpList)
        self._indexDownList = self:ListReverseOrder(self._indexDownList)
    end
end

-- 数组顺序反转
function AwaitCardList:ListReverseOrder( tbData )
    local data = {}
    local len = #tbData
    for i=1,len do
        data[i] = tbData[len-i-1]
    end
    return data
end

function AwaitCardList:Awake()
    self._cardGridUP = self._target.transform:Find("Up"):GetComponent("GridLayoutGroup")
    self._cardGridDown = self._target.transform:Find("Down"):GetComponent("GridLayoutGroup")
end

function AwaitCardList:create( target )
    self._target = target
    self:Awake()
end





