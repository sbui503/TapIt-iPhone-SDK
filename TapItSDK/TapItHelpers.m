//
//  TapItHelpers.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 5/16/13.
//
//

#import "TapItHelpers.h"


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
