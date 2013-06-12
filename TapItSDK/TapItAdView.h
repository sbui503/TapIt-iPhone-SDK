//
//  TapItAdView.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapItAdManagerDelegate.h"
#import "TapItMraidDelegate.h"

@class TapItRequest;

@interface TapItAdView : UIWebView <UIWebViewDelegate> {
}

@property (retain, nonatomic) TapItRequest *tapitRequest;
@property (assign, nonatomic) id<TapItAdManagerDelegate> tapitDelegate;
@property (assign, nonatomic) BOOL isLoaded;
@property (assign, nonatomic) BOOL interceptPageLoads;
@property (assign, nonatomic) BOOL isVisible;
@property (assign, nonatomic) BOOL wasAdActionShouldBeginMessageFired;

@property (assign, nonatomic) BOOL isMRAID;
@property (assign, nonatomic) id<TapItMraidDelegate> mraidDelegate;
@property (retain, nonatomic) NSString *mraidState;

- (void)repositionToInterfaceOrientation:(UIInterfaceOrientation)orientation;

- (void)setScrollable:(BOOL)scrollable;
//- (void)loadHTMLString:(NSString *)string;
- (void)loadData:(NSDictionary *)data;


//- (void)setIsVisible:(BOOL)visible;


- (void)syncMraidState;
- (void)fireMraidEvent:(NSString *)eventName withParams:(NSString *)jsonString;

@end
