-- FileName: 
-- Author:qiaoba
-- Date:2018-05-24 15:36:48
-- Purpose: 文件描述，请修改


ChooseFlowerPig = class("ChooseFlowerPig")


function ChooseFlowerPig:ctor()
    -- private Button tiaoButton;
    -- private Button wanButton;
    -- private Button tongButton;
    self._tiaoButton = nil
    self._wanButton = nil
    self._tongButton = nil
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
        self._target.transform.parent:SendMessage("SetFlowerPig", "万")
        self._target.gameObject:SetActive(false)
    end)
    
    self._tiaoButton.onClick:AddListener(function ( ... )
        GameAudio.getInstance():PlayaudioSourceRole("ui_click")
        self._target.transform.parent:SendMessage("SetFlowerPig", "条")
        self._target.gameObject:SetActive(false)
    end)

    self._tongButton.onClick:AddListener(function ( ... )
        GameAudio.getInstance():PlayaudioSourceRole("ui_click")
        self._target.transform.parent:SendMessage("SetFlowerPig", "筒")
        self._target.gameObject:SetActive(false)
    end)
end

function ChooseFlowerPig:create( target )
    self._target = target
    self:Awake()
    self:Start()
end

