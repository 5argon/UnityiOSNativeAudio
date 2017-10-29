using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

public class TesterVisual : MonoBehaviour {

	public Text text;
	public Text countText;
	public Text actionText;
	public AudioSource audioSource;
	public AudioClip clip;
	public AudioClip clip2;
	public AudioClip clip3;
	private Action action; 

	public void Test()
	{
		text.text = IosNativeAudio.Test(4).ToString();
	}

	public void Start()
	{
		StartCoroutine(Routine());
		IosNativeAudio.LoadSound();
	}

	public void PlaySoundRegister()
	{
		action = PlaySound;
	}

	public void PlaySound()
	{
		IosNativeAudio.PlaySound();
	}

	public void PlaySoundUnity1Register()
	{
		action = PlaySoundUnity;
	}
	public void PlaySoundUnity2Register()
	{
		action = PlaySoundUnity2;
	}

	public void PlaySoundUnity3Register()
	{
		action = PlaySoundUnity3;
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

    private float accumulateTime = 0;
    public void Update()
    {
		if(action != null)
		{
			actionText.text = action.Method.Name;
		}
    }

	IEnumerator Routine()
	{
		WaitForSeconds oneSec = new WaitForSeconds(1);
        while (true)
        {
            if (action != null)
            {
                action.Invoke();
            }
			countText.color = countText.color == Color.red ? Color.white : Color.red;
			yield return oneSec;
        }
	}
}
