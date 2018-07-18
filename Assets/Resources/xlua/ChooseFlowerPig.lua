-- FileName: 
-- Author:qiaoba
-- Date:2018-05-24 15:36:48
-- Purpose: 文件描述，请修改


ChooseFlowerPig = class("ChooseFlowerPig")


function ChooseFlowerPig:ctor()
    self._tiaoButton = nil    --Button
    self._wanButton = nil     --Button
    self._tongButton = nil    --Button
    self._target = nil   
end


function ChooseFlowerPig:Awake()
    self._tiaoButton = self._target.transform:Find("Tiao"):GetComponent("Button")
    self._wanButton = self._target.transform:Find("Wan"):GetComponent("Button")
    self._tongButton = self._target.transform:Find("Tong"):GetComponent("Button")
end

function ChooseFlowerPig:Start()
    self._wanButton.onClick:AddListener(function ( ... )
        GameAudio.getInstance():PlayaudioSourceRole("ui_click")
        -- self._target.transform.parent:SendMessage("SetFlowerPig", "万")
        GlobalNotify.postNotify(Const.MSG_PLAYER_SEL_FLOWERPIG,"万")
        self._target.gameObject:SetActive(false)
    end)
    
    self._tiaoButton.onClick:AddListener(function ( ... )
        GameAudio.getInstance():PlayaudioSourceRole("ui_click")
        -- self._target.transform.parent:SendMessage("SetFlowerPig", "条")
        GlobalNotify.postNotify(Const.MSG_PLAYER_SEL_FLOWERPIG,"条")
        self._target.gameObject:SetActive(false)
    end)

    self._tongButton.onClick:AddListener(function ( ... )
        GameAudio.getInstance():PlayaudioSourceRole("ui_click")
        -- self._target.transform.parent:SendMessage("SetFlowerPig", "筒")
        GlobalNotify.postNotify(Const.MSG_PLAYER_SEL_FLOWERPIG,"筒")
        self._target.gameObject:SetActive(false)
    end)
end

function ChooseFlowerPig:create( target )
    self._target = target
    self:Awake()
    self:Start()
end

