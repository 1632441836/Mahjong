-- FileName:
-- Author:yangna
-- Date:2018-05-21 10:52:22
-- Purpose: 文件描述，请修改

GameAudio = class("GameAudio")

local _gameAudioInstance = nil
function GameAudio.getInstance( ... )
    if (_gameAudioInstance == nil) then 
        _gameAudioInstance = GameAudio.new()
        _gameAudioInstance:create()
    end
    return _gameAudioInstance
end

function GameAudio:ctor()
    self._audios = {} --  //创建一个词典 存放我们的所有声音
    self._audioSources = {} -- //包含 背景音效 UI音效 指定音效
    self._audioSourceUI = {}
    self._audioSourceBG = {}
    self._audioSourceRole = {}
end

function GameAudio:Awake( ... )
    -- 加载Resources/Audio/目录下所有音频资源，返回值是AudioClip型的一维数组
    self._audioArray = CS.UnityEngine.Resources.LoadAll("Audio/")

    for i=0,self._audioArray.Length-1 do
        print(self._audioArray[i].name)
        self._audios[self._audioArray[i].name] = self._audioArray[i]
    end

    local gameCamera = CS.UnityEngine.GameObject.Find("Main Camera")
    self._audioSources = gameCamera:GetComponents(typeof(CS.UnityEngine.AudioSource))
    self._audioSourceUI = self._audioSources[0]
    self._audioSourceBG = self._audioSources[1]
    self._audioSourceRole = self._audioSources[2]
    self._audioSourceBG.loop = true
    -- self:PlayaudioSourceBG("bg-music")
end

function GameAudio:PlayaudioSourceUI(name)
    if (name == "") then
        name = "Button"
    end
    if (self._audios[name]) then 
        self._audioSourceUI.clip = self._audios[name]
        -- self._audioSourceUI:Play()
    end
end

function GameAudio:PlayaudioSourceBG(name)
    if (self._audios[name]) then
        self._audioSourceBG.clip = self._audios[name]
        -- self._audioSourceBG:Play()
    end
end

function GameAudio:PlayaudioSourceRole(name)
    if (self._audios[name]) then
        self._audioSourceRole.clip = self._audios[name]
        -- self._audioSourceRole:Play()
    end
end

function GameAudio:PlayaudioSourceAuto(name,pos)
    if (self._audios[name] and self._audioSourceRole.volume>0) then
        -- CS.UnityEngine.AudioSource.PlayClipAtPoint(self._audios[name], pos)
    end
end

function GameAudio:CloseaudioSourceUI(f) 
    self._audioSourceUI.volume = f
end

function GameAudio:CloseaudioSourceBG(f)
    self._audioSourceBG.volume = f 
end

function GameAudio:CloseaudioSourceRole(f)
    self._audioSourceRole.volume = f
end


function GameAudio:create(...)
    self:Awake(...)
end
