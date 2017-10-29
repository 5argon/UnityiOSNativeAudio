using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Tester : MonoBehaviour {

	public Text text;
	public AudioSource audioSource;
	public AudioClip clip;
	public AudioClip clip2;
	public AudioClip clip3;

	public void Test()
	{
		text.text = IosNativeAudio.Test(4).ToString();
	}

	public void LoadSound()
	{
		IosNativeAudio.LoadSound();
	}

	public void PlaySound()
	{
		IosNativeAudio.PlaySound();
	}

	public void PlaySoundUnity()
	{
		audioSource.PlayOneShot(clip);
	}
	public void PlaySoundUnity2()
	{
		audioSource.PlayOneShot(clip2);
	}

	public void PlaySoundUnity3()
	{
		audioSource.PlayOneShot(clip3);
	}

    public void Update()
    {
        if (Input.touchCount > 0)
        {
			if(Input.GetTouch(0).phase == TouchPhase.Began)
			{
				audioSource.PlayOneShot(clip);
			}
        }
	}
}
