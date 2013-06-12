//
//  TapItInterstitialAdViewController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/3/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdDelegates.h"
#import "TapItBrowserController.h"

@class TapItAdView;
@class TapItAdBrowserController;

@interface TapItInterstitialAdViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate>

@property (retain, nonatomic) TapItAdView *adView;
@property (assign, nonatomic) id<TapItInterstitialAdDelegate> tapitDelegate;
@property (assign, nonatomic) BOOL animated;
@property (assign, nonatomic) BOOL autoReposition;
@property (retain, nonatomic) UIButton *closeButton;
@property (retain, nonatomic) NSURL *tappedURL;

//- (void)openURLInFullscreenBrowser:(NSURL *)url;

- (void)showLoading;
- (void)hideLoading;

- (void)showCloseButton;
- (void)hideCloseButton;

@end
