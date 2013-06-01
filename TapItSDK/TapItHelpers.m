//
//  TapItHelpers.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 5/16/13.
//
//

#import "TapItHelpers.h"

#define DegreesToRadians(degrees) (degrees * M_PI / 180)

UIInterfaceOrientation TapItInterfaceOrientation()
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

UIWindow *TapItKeyWindow()
{
    return [UIApplication sharedApplication].keyWindow;
}

CGFloat TapItStatusBarHeight() {
    if ([UIApplication sharedApplication].statusBarHidden) {
        return 0.0;
    }
    
    CGSize size = [UIApplication sharedApplication].statusBarFrame.size;
    return MIN(size.width, size.height);
}

CGRect TapItApplicationFrame(UIInterfaceOrientation orientation)
{
    CGRect frame = TapItScreenBounds(orientation);
    CGFloat barHeight = TapItStatusBarHeight();
    frame.origin.y += barHeight;
    frame.size.height -= barHeight;
    
    return frame;
}

CGRect TapItScreenBounds(UIInterfaceOrientation orientation)
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    
    return bounds;
}


CGAffineTransform TapItRotationTransformForOrientation(UIInterfaceOrientation orientation) {
    CGFloat angle = 0.0;
    
    
//    switch (orientation) {
//            
//        case UIInterfaceOrientationLandscapeLeft:
//            angle = -DegreesToRadians(90);
//        case UIInterfaceOrientationLandscapeRight:
//            angle = DegreesToRadians(90);
//        case UIInterfaceOrientationPortraitUpsideDown:
//            angle = DegreesToRadians(180);
//        case UIInterfaceOrientationPortrait:
//        default:
//            angle = DegreesToRadians(0);
//    }
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown: angle = M_PI; break;
        case UIInterfaceOrientationLandscapeLeft: angle = -M_PI_2; break;
        case UIInterfaceOrientationLandscapeRight: angle = M_PI_2; break;
        default: break;
    }
    
    return CGAffineTransformMakeRotation(angle);
}