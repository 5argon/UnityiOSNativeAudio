//
//  NativeTouchRecognizer.m
//  Unity-iPhone
//
//  Created by Sirawat Pitaksarit on 2017/10/30.
//
#define LOG_TOUCH
#define LOG_UNITY_MESSAGE

#import "NativeTouchRecognizer.h"
#import "UnityAppController.h"
#import "UnityView.h"

@implementation NativeTouchRecognizer

NativeTouchRecognizer* gestureRecognizer;
UnityView* unityView;
CGRect screenSize;
CGFloat screenScale;

const char* _gameObjectName = "N";
const char* _methodName = "T";

typedef void (*NativeTouchDelegate)(int x, int y, int state);
NativeTouchDelegate callback;

+ (NativeTouchRecognizer*) GetInstance
{
    if(gestureRecognizer == nil)
    {
        gestureRecognizer = [[NativeTouchRecognizer alloc] init];
    }
    return gestureRecognizer;
}

+ (void) StopNativeTouch
{
    [unityView removeGestureRecognizer:gestureRecognizer];
}

+ (void) StartNativeTouch
{
    UnityAppController* uiApp = GetAppController();
    
    unityView = [uiApp unityView];
    screenScale = [[UIScreen mainScreen]scale];
    screenSize = [unityView bounds];
    
    NSLog(@"Starting native touch - Screen : %@ Scale : %f",NSStringFromCGRect(screenSize),screenScale);
    
    gestureRecognizer = [[NativeTouchRecognizer alloc] init];
    [unityView addGestureRecognizer:gestureRecognizer];
    
}

+(CGPoint) scaledCGPoint:(CGPoint)point
{
    //Retina display have /2 scale and have a smallest unit of pixel as 0.5.
    //This will multiply it back and eliminate the floating point
    
    //0,0 is at the top left of portrait orientation.
    
    return CGPointMake(point.x*screenScale, point.y*screenScale);
}

#ifdef LOG_TOUCH
+(void) logTouches:(NSSet<UITouch*> *) touches
{
    NSArray<UITouch *>* touchesArray = [touches allObjects];
    for(int i = 0; i < [touchesArray count]; i++) {
        UITouch* touch = touchesArray[i];
        NSLog(@"#%d Loc:%@ Prev:%@ Radius:%f Phase:%d",
              i,
              NSStringFromCGPoint([NativeTouchRecognizer scaledCGPoint:[touch locationInView:nil]]),
              NSStringFromCGPoint([NativeTouchRecognizer scaledCGPoint:[touch previousLocationInView:nil]]),
              [touch majorRadius],
              [touch phase]);
    }
}
#endif

 +(const char*) encodeTouch: (UITouch*) touch
 {
     CGPoint location = [NativeTouchRecognizer scaledCGPoint:[touch locationInView:nil]];
     return [[NSString stringWithFormat:@"%d-%d-%d", (int)location.x, (int)location.y,[touch phase]] UTF8String];
 }

+(void) sendTouchesToUnity:(NSSet<UITouch*> *) touches
{
    NSArray<UITouch *>* touchesArray = [touches allObjects];
    for(UITouch* touch in touchesArray)
    {
#ifdef LOG_UNITY_MESSAGE
        NSLog(@"To Unity : %@",[NSString stringWithCString:[NativeTouchRecognizer encodeTouch:touch] encoding:NSUTF8StringEncoding]);
#endif
        CGPoint location = [NativeTouchRecognizer scaledCGPoint:[touch locationInView:nil]];

        callback( (int)location.x, (int) location.y, (int)[touch phase]);

        // if([touch phase] == UITouchPhaseBegan)
        // {
        //     [[IosNativeAudio GetInstance] PlaySoundIos];
        // }
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
#ifdef LOG_TOUCH
    [NativeTouchRecognizer logTouches:touches];
#endif
    [NativeTouchRecognizer sendTouchesToUnity:touches];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
#ifdef LOG_TOUCH
    [NativeTouchRecognizer logTouches:touches];
#endif
    [NativeTouchRecognizer sendTouchesToUnity:touches];
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
#ifdef LOG_TOUCH
    [NativeTouchRecognizer logTouches:touches];
#endif
    [NativeTouchRecognizer sendTouchesToUnity:touches];
}

@end

extern "C" {

    void _StopNativeTouch() {
        [NativeTouchRecognizer StopNativeTouch];
    }
    
    void _StartNativeTouch(NativeTouchDelegate nativeTouchDelegate) {
        callback = nativeTouchDelegate;
        [NativeTouchRecognizer StartNativeTouch];
    }
    
}
