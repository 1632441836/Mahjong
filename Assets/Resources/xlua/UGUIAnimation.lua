-- FileName: 
-- Author:qiaoba
-- Date:2018-05-22 17:16:35
-- Purpose: 骰子的帧序列动画

UGUIAnimation = class("UGUIAnimation")

function UGUIAnimation:ctor( ... )
    -- private Image ImageSource;
    -- private Sprite _lastImage;
    -- private int mCurFrame = 0;
    -- private float mDelta = 0;

    -- public float FPS = 5;
    -- public List<Sprite> SpriteFrames;
    -- public bool IsPlaying = false;
    -- public bool Foward = true;
    -- public bool AutoPlay = false;
    -- public bool Loop = false;

    self._imageSource = nil    --Image
    self._lastImage = nil      --Sprite
    self._mCurFrame = 1        --int
    self._mDelta = 0           --int
    self._FPS = 20             --float
    self._spriteFrames = {}    --List<Sprite> 
    self._isPlaying = false    --bool
    self._foward = true       
    self._autoPlay = false
    self._loop = false
end


function UGUIAnimation:FrameCount()
    return #self._spriteFrames
end

function UGUIAnimation:getLastImage()
    return self._lastImage
end

function UGUIAnimation:setLastImage(value)
    self._lastImage = value
end

function UGUIAnimation:Awake()
    self._imageSource = self._target:GetComponent(typeof(CS.UnityEngine.UI.Image))
end

function UGUIAnimation:Start()
    if (self._autoPlay) then
        if(self._foward) then
            self:Play()
        else
            self:PlayReverse()
        end
    end
end

function UGUIAnimation:Update()
    if (not self._isPlaying or 0 == self:FrameCount()) then
        return
    end

    self._mDelta = self._mDelta + CS.UnityEngine.Time.deltaTime

    if (self._mDelta > 1 / self._FPS) then
        self._mDelta = 0
        self:SetSprite(self._mCurFrame)

        if (self._foward) then
            self._mCurFrame = self._mCurFrame + 1
        else
            self._mCurFrame = self._mCurFrame - 1
        end

        if (self._mCurFrame > self:FrameCount()) then
            if (self._loop) then
                self._mCurFrame = 1
            else
                self:Completion()
                return
            end
        elseif (self._mCurFrame <= 0) then
            if (self._loop) then
                self._mCurFrame = self:FrameCount()
            else
                self:Completion()
                return
            end
        end
    end
end

function UGUIAnimation:SetSprite(idx)
    self._imageSource.sprite = self._spriteFrames[idx]
    -- 该部分为设置成原始图片大小，如果只需要显示Image设定好的图片大小，注释掉该行即可。
    -- //ImageSource.SetNativeSize();
end

function UGUIAnimation:Play()
    self._mCurFrame = 1
    self._isPlaying = true
    self._foward = true
end

function UGUIAnimation:PlayReverse()
    self._mCurFrame = #self._spriteFrames
    self._isPlaying = true
    self._foward = false
end


function UGUIAnimation:Pause()
    self._isPlaying = false
end

function UGUIAnimation:Resume()
    if (not self._isPlaying) then
        self._isPlaying = true
    end
end

function UGUIAnimation:Stop()
    self._mCurFrame = 1
    self:SetSprite(self._mCurFrame)
    self._isPlaying = false
end

function UGUIAnimation:Rewind()
    self._mCurFrame = 1
    self:SetSprite(self._mCurFrame)
    self:Play()
end

function UGUIAnimation:Completion()
    self._isPlaying = false
    if(self._lastImage) then
        self._imageSource.sprite = self._lastImage
    end
end

-- target:骰子控件下的1，2两个子控件
function UGUIAnimation:create( target )
    self._target = target
    for i=1,20 do
        self._spriteFrames[i] = CS.UnityEngine.Resources.Load("UIs/Touzi/touzi_" .. i,typeof(CS.UnityEngine.Sprite))
    end

    self:Awake()
    self:Start()
end