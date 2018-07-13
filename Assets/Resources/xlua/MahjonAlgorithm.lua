-- FileName: 
-- Author:yangna
-- Date:2018-05-25 16:29:11
-- Purpose: 文件描述，请修改


MahjonAlgorithm = class("MahjonAlgorithm")

local instance = nil
MahjonAlgorithm.getInstance = function ( ... )
    if (not instance) then
        instance = MahjonAlgorithm.new()
        instance:create()
    end
    return instance
end

function MahjonAlgorithm:ctor()

end

--  是否能碰牌
--  handcard: 原为List<Card>类型，替换成了table
--  gocard: Card类型
--  return: bool
function MahjonAlgorithm:IsPeng(handcard, gocard)
    local mid = self:TraverseSpecifiedNumber(handcard,2)
    if (#mid >= 2) then
        for k,card in pairs(mid) do
            if (gocard:getSize() == card:getSize() and gocard:getCardMark() == card:getCardMark()) then
                return true
            end
        end
    end
    return false
end

--  是否能杠牌
--  handcard: 原为List<Card>类型，替换成了table
--  gocard: Card类型
--  number: int
--  return: bool
function MahjonAlgorithm:IsGang(handcard, gocard, number)
    local mid = self:TraverseSpecifiedNumber(handcard, number)
    if (#mid >= number) then
        for k,card in pairs(mid) do
            if (gocard:getSize() == card:getSize() and gocard:getCardMark() == card:getCardMark()) then
                return true
            end
        end
    end
    return false
end


--  是否胡牌
--  handcard:原为List<Card>类型，替换成了table
--  return:bool
function MahjonAlgorithm:IsHu(tbHandcard)
    print("-------------------MahjonAlgorithm:IsHu,tbHandcard=",#tbHandcard)
    local count = {}
    for i=1,27 do
        count[i] = 0
    end

    for k,card in pairs(tbHandcard) do
        local idx = nil
        print("-------------------MahjonAlgorithm:IsHu, card:getCardMark=",card:getCardMark())

        if (card:getCardMark() == "万") then
            idx = card:getSize()
        elseif (card:getCardMark() == "条") then
            idx = card:getSize() + 9
        elseif (card:getCardMark() == "筒") then   
            idx = card:getSize() + 9 * 2
        end
        
        print("-------------------MahjonAlgorithm:IsHu, idx=",idx)
        if (idx) then
            count[idx] = count[idx] or 0
            count[idx] = count[idx] + 1
        end
    end

    print("-------------------MahjonAlgorithm:IsHu,count=",#count)

    return self:TryHu(count, #tbHandcard)
end

-- 
-- handcard:原为List<Card>类型，处理成table
-- firstMark：string
function MahjonAlgorithm:IsFirstMark(tbHandcard, firstMark)
    firstMark = firstMark or ""
    local count = 0
    for k,card in pairs(tbHandcard) do
        if (card:getCardMark() == firstMark) then
            count = count + 1
        end
    end

    return count
end

-- handcard:原为List<Card>类型，处理成tableGoCard
-- firstMark：string
function MahjonAlgorithm:GoCard(tbHandcard, firstMark)
    firstMark = firstMark or ""
    local tempCardList = {}

    for k,card in pairs(tbHandcard) do
        if (card:getCardMark() == firstMark) then
            return card
        else
            tempCardList[#tempCardList + 1] = card
        end
    end

    print("----------------MahjonAlgorithm_GoCard,#tempCardList=,firstMark=",#tempCardList,firstMark)
   --暂时这里随机咯 以后可以在这里写多种算法加强机器人自动出牌
    local next = math.random(1,#tempCardList)
    return tempCardList[next]
end

-- 遍历手中相同牌的指定数量
-- handcard：原为List<Card>类型，替换成table 
-- number：int
-- return: 原为List<Card>类型，替换成table 
function MahjonAlgorithm:TraverseSpecifiedNumber(tbHandcard, number)
    local cards = {}
    local tempNumber = 0
    for i=1,#tbHandcard do
        for j=1,#tbHandcard do
            if (tbHandcard[i]:getSize() == tbHandcard[j]:getSize() and tbHandcard[i]:getCardMark() == tbHandcard[j]:getCardMark()) then
                tempNumber = tempNumber + 1
            end
        end
        if (tempNumber == number) then
            table.insert(cards,tbHandcard[i])
        end
        tempNumber = 0
    end
    return cards
end


--  利用递归属性去检测是否能糊牌成功返回真失败假
--  tbCount:原为int[]，替换成table
--  cardNumber：int
--  return:bool
function MahjonAlgorithm:TryHu(tbCount, cardNumber)
    if (cardNumber == 0) then
        return true 
    end
    
    print("-------------------MahjonAlgorithm:TryHu, #tbCount=",#tbCount)
    
    assert(#tbCount>0,debug.traceback())

    if (cardNumber % 3 == 2) then
        -- 一副牌必须有对牌 没有优先判断
        for i = 1, 27 do
            if (tbCount[i] >= 2) then
                tbCount[i] = tbCount[i] - 2
                if (self:TryHu(tbCount, cardNumber - 2)) then                
                    return true
                else
                    tbCount[i] = tbCount[i] + 2
                end
            end
        end
    elseif (cardNumber % 3 == 0) then
        --是否还有三张一样的牌 
        for i = 1, 27 do
            if (tbCount[i] >= 3) then
                tbCount[i] = tbCount[i] - 3
                if (self:TryHu(tbCount, cardNumber - 3)) then
                    return true
                else
                    tbCount[i] = tbCount[i] + 3
                end
            end
        end
        --三张一起是否是顺子
        local k = nil
        for i = 0, 2 do
            k = i * 9
            for j = 1, 7 do    
                if (tbCount[k + j] > 0 and tbCount[k + j + 1] > 0 and tbCount[k + j + 2] > 0) then
                    tbCount[k + j] = tbCount[k + j] - 1
                    tbCount[k + j + 1] = tbCount[k + j + 1] - 1
                    tbCount[k + j + 2] = tbCount[k + j + 2] - 1
                    if (self:TryHu(tbCount, cardNumber - 3)) then
                        return true
                    else
                        tbCount[k + j] = tbCount[k + j] + 1
                        tbCount[k + j + 1] = tbCount[k + j + 1] + 1
                        tbCount[k + j + 2] = tbCount[k + j + 2] + 1
                    end
                end
            end         
        end
    end
    return false
end



function MahjonAlgorithm:create( ... )

end

