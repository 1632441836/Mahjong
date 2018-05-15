local Desktop = {}

function Desktop.create(self)
    print("desktop create")
    CS.UnityEngine.SceneManagement.SceneManager.LoadScene("Desktop")
end

return Desktop