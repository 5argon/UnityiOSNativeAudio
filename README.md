# Unity iOS/Android Native Audio, Native Touch, and latency

[![youtube](youtube.png)](https://www.youtube.com/watch?v=6Wot7lzZR5o)

This Unity project is the continuation of my research [Unity's Mobile Audio Latency Problem And Solutions](http://exceed7.com/mobile-native-audio/research.html) which contains many false conclusion but still a good foundation for this.

Previously I have made some assumptions about using OS's native audio method in Unity would solve the problem. In this project I show that native audio helps but that is not all, we need a native TOUCH INPUT plugin to solve the "perceived" audio latency problem.

**Update 13/04/2018** : [Now PART 3 of the video above is available.](https://www.youtube.com/watch?v=Riws7Ais3bo) It improve on the iOS side by using `OpenAL` instead of `AVAudioPlayer`. I have confirmed we can get even better latency that way. So in this page when you see me saying "native audio does not help that much" that is not true anymore! The improvement is now significant with `OpenAL` (at least on iOS) Also, a website for pre-made solution [Native Audio](http://exceed7.com/native-audio/) and [iOS Native Touch](http://exceed7.com/ios-native-touch/) are now up.)

**Update 17/08/2018** : At the **Android** side, I have successfully improved the audio latency by using OpenSL ES + good double buffering technique + ensuring the fast track by going great length as far as resampling the audio to match the liking of each Android device. You can read the research here [Android Native Audio Primer for Unity Developers](https://gametorrahod.com/androids-native-audio-primer-for-unity-developers-65acf66dd124) to get how to achieve minimum latency on Android. All of that will be integrated into [Native Audio](http://exceed7.com/native-audio/) plugin version 2.0 or if you want to try implementing it yourself the mentioned research article should be enough.

So if you see me saying native audio on android does not help reducing latency much, it is not true anymore. Also I remembered saying somewhere that OpenSL ES is not that much difference from Java's `AudioTrack` but that is because of my incompetence at the time. I didn't know how to achieve fast track with NDK, didn't know about resampling, and did not do double buffering. OpenSL ES is now the way to go according to [the official Google document](https://developer.android.com/ndk/guides/audio/). (Along with **AAudio** which I haven't tried yet but it only works for Oreo+)

## Native Audio is not all of the solution, we also need Native Touch

I have written the iOS native audio plugin for use with Unity (this repo). However I was surprised that this time the average nail sound to response sound was only a bit (1-5%) better than `AudioSource.Play()`. This same iPod running this test with [iOSSoundTest](https://github.com/5argon/iOSSoundTest) have much lower time difference.

But the code of iOSSoundTest and this Unity-iOS native plugin is almost the same! (Please check `Plugins/iOS/iOSNativeAudio.mm`) What else could Unity add?

You can check the result here (go to sheet 2) : https://docs.google.com/spreadsheets/d/1kSqkLM2C1NjxXg2oBcZzsVc9ooT4pZo2wSOY0Vt8C7k/edit?usp=sharing

What this means is... the perceived audio latency (the recorded nail sound to response sound interval) is bad not just because Unity's thick audio layer, but it is also because of Unity's input latency. The XCode's native button surely receives touch faster than Unity's button.

## Are you sure it is because of touch?

Just in case watching the [YouTube video](https://www.youtube.com/watch?v=6Wot7lzZR5o) at the top of this page does not convince you enough, I have double check this in Unity with both uGUI's `EventSystem` and `Input.GetTouch`. Both results in the same latency.

I have triple check the new assumption with the second scene "Visual" which has a coroutine that call any method every 1 second. (No input latency involved) Everytime it will change the font's color from red to white and vice versa. Without nail's sound to measure, I run this and use a separate DSLR camera with 60 fps to capture the screen along with the sound, finally use Premiere Pro to examine the period between the font changing color to the peak of the sound. That would be exactly Unity's audio latency, which the result is 3-4 frames for both native iOS audio plugin and Unity's `AudioSource.Play` with all formats. (Native one is sometimes better, but not significant)

## Summary

The bottom line is, using both Native Audio **and Native Touch** together we can make a Unity app that reacts as fast as a native iOS app. Haven't confirmed on the Android side but I assume it might be the same.

(I didn't say I fixed the infamous Android's horrible audio latency problem with this. It is that Unity Android is somehow more horrible than native Android's already horrible latency and we can close that gap using Native Audio + Native Touch. We try to bypass anything Unity might add in exchange for more complex API usage.)

Another intepretation of this finding is that all Unity games in the market has delayed touch (as long as you get them from `Input.GetTouch`). Your device is capable of providing faster touch experience by using Native Touch.

# Plugin Release

Both plugins ([Native Audio](http://exceed7.com/native-audio/) and [iOS Native Touch](http://exceed7.com/ios-native-touch/)) are planned to be on the Asset Store later after I have made sure it is working fine in my own music game Mel Cadence (http://exceed7.com/mel-cadence/).

If you don't want to wait or don't want to pay me (😭), this project already contains the most barebone form of both Native Audio and Native Touch. You can hack your own solution starting from examples in my code if you want. Part of it utilize the result from [this research](https://github.com/5argon/UnitySendMessageEfficiencyTest) to make sure the talk back from native to C# is the fastest possible.

EDIT : Both plugins are now available [Native Audio](http://exceed7.com/native-audio/), [iOS Native Touch](http://exceed7.com/ios-native-touch/).

# Update (3/11/2017) : The state of Android

I have tested the Native Touch on Android. Unfortunately I could not get the touch to be faster than Unity ones. In fact it is a little bit slower sometimes.

The method I use I believe is the fastest way I can do to make Java talk to C#.
1. `UnityPlayer` in `UnityPlayerActivity` was replaced directly with my own sub class.
2. My subclass has a new `onTouchEvent`
3. This `onTouchEvent` did not use `UnitySendMessage` but using @FunctionalInterface to call to C#. It received this interface using Unity C#'s `AndroidJavaProxy`
4. The sound playing method in C# is further optimized to play using `AndroidJavaProxy`'s `Invoke` override to avoid ["look for c# methods matching the signature"](https://docs.unity3d.com/ScriptReference/AndroidJavaProxy.Invoke.html)
5. I am not even sending back any parameters yet, like touch coordinates, etc.

I could not think of any faster way than this. So I would like to conclude that it is pointless to use Native Touch with Unity Android. There is a chance that different device might behave differently and in fact maybe faster or even slower. (My device is Nexus 5) But I won't be including Android support in my Native Touch plugin and name it iOS Native Touch instead. One advantage that you would like Native Touch on Android is for getting [other native touch parameters](https://developer.android.com/reference/android/view/MotionEvent.html) that Unity does not provide, rather than a speed improvement.

However there is one more rather extreme way, that is you don't talk to C# at all. All the resources to determine whether Android should play audio on a particular touch or not should be completely reside in Java! Then after the hijacked touch and some ifs, we should call to Android Native Audio directly.. It will be very hardcore from game design perspective, for example how can I determine should I play "Perfect" sound or "Great" sound before sending touch to Unity? Is it even possible in the same frame?

# Update (17/08/2018) : The state of Android 2

I recently got a new phone, so I tried the same approach as the last update. (With a little bit of optimization on shorter code path, would not make much difference I think) But this time I managed to get the response time faster for about 10-16ms. It sounds small, but for perspective this is about a half of perfect window for many music games, 33ms. On game like DDR the timing for Marvelous (highest) is just 16ms so if you use vanilla Unity input to make DDR the player would be randomly thrown into or out of Marvelous. Some samples from my "Android Native Touch" is as follows :

![android native touch time](https://forum.unity.com/attachments/screenshot-2018-08-16-17-14-32-png.292035/)

Also my plugin can get the real native timestamp that the touch really happen and can be outside of the frame (similar to the new input system that Unity team is making now) so the time does not get locked to the frame rate. Even if you must react to the touch in-frame, you know the real time that the touch happen to react better, and more truthfully.

My native touch plugin was previously named "iOS Native Touch" because I thought it is useless on Android, but with this 10-16ms improvement I think it is now meaningful. In the next version it would include Android support and renamed to just "Native Touch".
