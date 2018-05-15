﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System;


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
		scriptEnv = luaEnv.NewTable ();

		LuaTable meta = luaEnv.NewTable ();
		meta.Set ("__index", luaEnv.Global);
		scriptEnv.SetMetaTable (meta);
		meta.Dispose ();

		scriptEnv.Set ("self", this);
		foreach (var injection in injections) {
			scriptEnv.Set (injection.name, injection.value);
		}
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
//		Debug.Log ("start");
		if (luaStart != null) {
			luaStart ();
		}
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
		Debug.Log ("OnDestory");
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
