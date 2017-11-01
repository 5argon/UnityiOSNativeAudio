using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class IosNativeAudio {

	/* Interface to native implementation */
	
	[DllImport ("__Internal")]
	private static extern int _LoadSound();
	
	[DllImport ("__Internal")]
	private static extern void _PlaySound();

	[DllImport ("__Internal")]
	private static extern int _Test(int a);

	public static void LoadSound()
	{
		_LoadSound();
	}

	public static void PlaySound()
	{
		_PlaySound();
	}

	public static int Test(int a)
	{
		return _Test(a);
	}
}
