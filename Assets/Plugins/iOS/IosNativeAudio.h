
#import <AVFoundation/AVFoundation.h>

@interface IosNativeAudio : NSObject
{
    AVAudioPlayer *_audioPlayer;
    SystemSoundID mySound;
}

- (void)LoadSoundIos;
- (void)PlaySoundIos;

@end

