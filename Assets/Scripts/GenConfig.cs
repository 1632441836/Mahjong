using UnityEngine;
using System.Collections.Generic;
using XLua;
using System;

public static class GenConfig
{
	[LuaCallCSharp]
	public static List<Type> LuaCallCSharp = new List<Type> () {
		typeof(System.Object),
		typeof(UnityEngine.Object),
		typeof(Vector2),
		typeof(Vector3),
		typeof(Vector4),
		typeof(Quaternion),
		typeof(Color),
		typeof(Ray),
		typeof(Bounds),
		typeof(Ray2D),
		typeof(Time),
		typeof(GameObject),
		typeof(Component),
		typeof(Behaviour),
		typeof(Transform),
		typeof(Resources),
		typeof(TextAsset),
		typeof(Keyframe),
		typeof(AnimationCurve),
		typeof(AnimationClip),
		typeof(MonoBehaviour),
		typeof(ParticleSystem),
		typeof(SkinnedMeshRenderer),
		typeof(Renderer),
		typeof(WWW),
		typeof(Light),
		typeof(Mathf),
		typeof(System.Collections.Generic.List<String>),
		typeof(Action<string>),
		typeof(UnityEngine.Debug),
		typeof(System.Collections.Generic.List<UnityEngine.UI.Image>),
		typeof(WaitForSeconds),
		typeof(WaitForEndOfFrame),
		typeof(WaitForFixedUpdate),
		typeof(WaitForSecondsRealtime),
		typeof(List<string>),
		typeof(Dictionary<string, int>),

	};

	[CSharpCallLua]
	public static List<Type> CSharpCallLua = new List<Type> () {
		typeof(Action),
		typeof(Func<double, double, double>),
		typeof(Action<string>),
		typeof(Action<double>),
		typeof(UnityEngine.Events.UnityAction),
		typeof(System.Collections.IEnumerator),

	};

	[BlackList]
	public static List<List<string>> BlackList = new List<List<string>>()  {
		new List<string>(){"UnityEngine.WWW", "movie"},
		#if UNITY_WEBGL
		new List<string>(){"UnityEngine.WWW", "threadPriority"},
		#endif
		new List<string>(){"UnityEngine.Texture2D", "alphaIsTransparency"},
		new List<string>(){"UnityEngine.Security", "GetChainOfTrustValue"},
		new List<string>(){"UnityEngine.CanvasRenderer", "onRequestRebuild"},
		new List<string>(){"UnityEngine.Light", "areaSize"},
		#if UNITY_2017_1_OR_NEWER
		new List<string>(){"UnityEngine.Light", "lightmapBakeType"},
		new List<string>(){"UnityEngine.WWW", "MovieTexture"},
		new List<string>(){"UnityEngine.WWW", "GetMovieTexture"},
		#endif
		new List<string>(){"UnityEngine.AnimatorOverrideController", "PerformOverrideClipListCleanup"},
		#if !UNITY_WEBPLAYER
		new List<string>(){"UnityEngine.Application", "ExternalEval"},
		#endif
		new List<string>(){"UnityEngine.GameObject", "networkView"}, //4.6.2 not support
		new List<string>(){"UnityEngine.Component", "networkView"},  //4.6.2 not support
		new List<string>(){"System.IO.FileInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
		new List<string>(){"System.IO.FileInfo", "SetAccessControl", "System.Security.AccessControl.FileSecurity"},
		new List<string>(){"System.IO.DirectoryInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
		new List<string>(){"System.IO.DirectoryInfo", "SetAccessControl", "System.Security.AccessControl.DirectorySecurity"},
		new List<string>(){"System.IO.DirectoryInfo", "CreateSubdirectory", "System.String", "System.Security.AccessControl.DirectorySecurity"},
		new List<string>(){"System.IO.DirectoryInfo", "Create", "System.Security.AccessControl.DirectorySecurity"},
		new List<string>(){"UnityEngine.MonoBehaviour", "runInEditMode"},
		#if !UNITY_5_6_OR_NEWER

		#endif
	};
}

