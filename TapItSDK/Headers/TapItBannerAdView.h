//
//  TapItBannerAd.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TapItConstants.h"
#import "TapItAdDelegates.h"

@class TapItRequest;

@interface TapItBannerAdView : UIView

@property (assign, nonatomic) id<TapItBannerAdViewDelegate> delegate;
@property (assign, nonatomic) BOOL animated;
@property (assign, nonatomic) BOOL autoReposition;
@property (assign, nonatomic) BOOL showLoadingOverlay;
@property (assign, nonatomic) BOOL shouldReloadAfterTap;
@property (readonly) BOOL isServingAds;
@property (assign) TapItBannerHideDirection hideDirection;
@property (assign, nonatomic) UIViewController *presentingController;
@property NSUInteger locationPrecision;

- (BOOL)startServingAdsForRequest:(TapItRequest *)request;
- (void)updateLocation:(CLLocation *)location;
- (void)hide;
- (void)cancelAds;

- (void)pause;
- (void)resume;

- (void)repositionToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end
