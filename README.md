# UnityiOSNativeAudio

This Unity project is the continuation of my research [Unity's Mobile Audio Latency Problem And Solutions](http://exceed7.com/mobile-native-audio/research.html)

At that time the research turns out that native audio is much faster than Unity ones even with Best Latency setting. But I was wrong.

I have written the iOS native audio plugin for use with Unity (this repo). However I was surprised that this time the average Sargon is the same as `AudioSource.Play()`. This same iPod running Sargon test with [iOSSoundTest](https://github.com/5argon/iOSSoundTest) have much lower Sargon.

But the code of iOSSoundTest and this Unity-iOS native plugin is almost the same! (Please check `Plugins/iOS/iOSNativeAudio.mm`) What else could Unity add?

You can check the result here (go to sheet 2) : https://docs.google.com/spreadsheets/d/1kSqkLM2C1NjxXg2oBcZzsVc9ooT4pZo2wSOY0Vt8C7k/edit?usp=sharing

I will uplad a YouTube video later here : 

What this means is... the perceived audio latency (the Sargon value) is bad not because Unity's audio playing ability, but it is because of Unity's input latency. The gap from my nail sound to the sound you hear is large because of input latency. The XCode's button received the touch faster than Unity's button. I have double check this in Unity with both uGUI's `EventSystem` and `Input.GetTouch`. Both results in the same Sargon.

## Is this the end? Can we have low audio latency?

The next thing to try is to write a *Native iOS Input* plugin instead of *Native iOS Audio* to solve the *audio latency* problem. Sounds funny, but that's what I learned from this experiment.
