using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using AOT;

public class NativeTouch{

	[DllImport ("__Internal")]
	private static extern void _StartNativeTouch(NativeTouchDelegate callback);
	
	[DllImport ("__Internal")]
	private static extern void _StopNativeTouch();

    public delegate void NativeTouchDelegate(int x, int y, int state);

	[MonoPInvokeCallback(typeof(NativeTouchDelegate))]
    public static void NativeTouchCallback(int x, int y, int state)
	{
		Debug.Log("Unity Received " + x + " " + y + " " + state);
		//Debug.Log("Unity Received " + message);
		if(state == 0)
		//if(message.Split('-')[2] == "0")
		{
			Tester.Instance.PlaySound();
		}
	}

	public static void StartNativeTouch()
	{
		_StartNativeTouch(NativeTouchCallback);
	}

	public static void StopNativeTouch()
	{
		_StopNativeTouch();
	}
}
