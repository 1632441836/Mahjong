using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System;
using UnityEngine.UI;

[System.Serializable]
public class Injection
{
	public string name;
	public GameObject value;
}

[LuaCallCSharp]
public class GameEnter : MonoBehaviour {
	internal static LuaEnv luaEnv = new LuaEnv ();
	internal static float lastGCTime = 0;
	internal const float GCInterval = 1;

	public TextAsset luaScript;
	public Injection[] injections;

	private Action luaStart;
	private Action luaUpdate;
	private Action luaOnDestroy;

	private LuaTable scriptEnv;

	// Update is called once per frame
	void Awake () {
		Debug.Log("===============GameEnter.Awake");
		scriptEnv = luaEnv.NewTable ();

		LuaTable meta = luaEnv.NewTable ();
		meta.Set ("__index", luaEnv.Global);
		scriptEnv.SetMetaTable (meta);
		meta.Dispose ();

		scriptEnv.Set ("self", this);
		foreach (var injection in injections) {
			scriptEnv.Set (injection.name, injection.value);
		}
		Debug.Log ("=======");
		Debug.Log (luaScript.text);
		luaEnv.DoString (luaScript.text, "GameEnter", scriptEnv);

		Action luaAwake = scriptEnv.Get<Action> ("awake");

		scriptEnv.Get ("start", out luaStart);
		scriptEnv.Get ("update", out luaUpdate);
		scriptEnv.Get ("ondestroy", out luaOnDestroy);

		if (luaAwake != null) {
			luaAwake ();
		}
	}

	void Start () {
		Debug.Log ("===============GameEnter.Start");
//		Debug.Log ("start");
		if (luaStart != null) {
			luaStart ();
		}

		List<String> ls = new List<String>();

		Debug.Log("typeof(GameObject)==" + typeof(GameObject));
		Debug.Log("typeof(List<String>)==" + typeof(List<String>));
		Debug.Log("typeof(List<int>)==" + typeof(List<int>));
		Debug.Log("typeof(List<Image>)==" + typeof(List<Image>));
		Debug.Log("typeof(Dictionary<string, Transform>)==" + typeof(Dictionary<string, Transform>));
		Debug.Log("typeof(Dictionary<string, Sprite>)==" + typeof(Dictionary<string, Sprite>));
	}

	void Update () {
//		Debug.Log ("Update");
		if (luaUpdate != null) {
			luaUpdate ();
		}
		if (Time.time - GameEnter.lastGCTime > GCInterval)
		{
			luaEnv.Tick();
			GameEnter.lastGCTime = Time.time;
		}
	}

	void OnDestory() {
		Debug.Log ("===============GameEnter.OnDestory");
		if (luaOnDestroy != null) {
			luaOnDestroy ();
		}
		luaOnDestroy = null;
		luaUpdate = null;
		luaStart = null;
		scriptEnv.Dispose ();
		injections = null;
	}
}
