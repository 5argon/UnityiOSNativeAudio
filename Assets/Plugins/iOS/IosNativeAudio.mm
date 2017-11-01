
#import "IosNativeAudio.h"

@implementation IosNativeAudio

static IosNativeAudio* delegateObject;

- (void)LoadSoundIos {
    
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/Data/Raw/HitSound.wav", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &mySound);
    NSLog(@"Load!");
}

- (void)PlaySoundIos {
    [_audioPlayer stop];
    [_audioPlayer setCurrentTime:0];
    [_audioPlayer play];
    NSLog(@"Play!");
}

+ (IosNativeAudio*) GetInstance
{
    if(delegateObject == nil)
    {
        delegateObject = [[IosNativeAudio alloc]init];
    }
    return delegateObject;
}

@end



extern "C" {
    
    int _Test(int a)
    {
        return a+1;
    }
    
    void _LoadSound() {
        delegateObject = [[IosNativeAudio alloc]init];
        [delegateObject LoadSoundIos];
    }
    
    void _PlaySound() {
        [delegateObject PlaySoundIos];
    }
    
}



