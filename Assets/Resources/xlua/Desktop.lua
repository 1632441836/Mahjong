
local Desktop = {}

function Desktop.create(self)
    print("desktop create")
    CS.UnityEngine.SceneManagement.SceneManager.LoadScene("Desktop")
end

-- 开始按钮
function Desktop.onStartBtn( ... )
    local startBtn = CS.UnityEngine.GameObject.Find("Start_Button"):GetComponent("Button")
	startBtn.onClick:AddListener(function ()
		print("start")
		startBtn:SetActive(false)
	end)
end




return Desktop