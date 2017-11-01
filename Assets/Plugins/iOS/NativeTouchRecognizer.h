//
//  NativeTouchRecognizer.h
//  Unity-iPhone
//
//  Created by Sirawat Pitaksarit on 2017/10/30.
//

#ifndef NativeTouchRecognizer_h
#define NativeTouchRecognizer_h

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface NativeTouchRecognizer : UIGestureRecognizer
{
 
}

+ (void) StartNativeTouch;
+ (void) StopNativeTouch;
+ (NativeTouchRecognizer*) GetInstance;

@end

#endif
