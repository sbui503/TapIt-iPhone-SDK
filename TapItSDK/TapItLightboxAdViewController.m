//
//  TapItActionSheetAdViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/2/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import "TapItLightboxAdViewController.h"
#import "TapItBrowserController.h"
#import "TapItAdView.h"

@interface TapItLightboxAdViewController ()

- (void)closeTapped:(id)sender;

@end



@implementation TapItLightboxAdViewController

@synthesize closeButton, tappedURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.closeButton = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.adView setCenter:self.view.center];
    [self.view addSubview:(UIView *)self.adView];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
}


- (void)showCloseButton {
    if (!self.closeButton) {
        
        UIImage *closeButtonBackground = [UIImage imageNamed:@"TapIt.bundle/interstitial_close_button.png"];
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.closeButton.imageView.contentMode = UIViewContentModeCenter;
        [self.closeButton setImage:closeButtonBackground forState:UIControlStateNormal];
        
        [self.closeButton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.adView addSubview:self.closeButton];
        self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        CGRect appFrame = TapItApplicationFrame(TapItInterfaceOrientation());
        self.closeButton.frame = CGRectMake(appFrame.size.width - 50, 0, 50, 50);
    }
    
    [self.adView bringSubviewToFront:self.closeButton];
}

- (void)hideCloseButton {
    if (!self.closeButton) {
        return;
    }
    [self.closeButton removeFromSuperview];
    self.closeButton = nil;
}



- (void)closeTapped:(id)sender {
    id<TapItInterstitialAdDelegate> tDel = [self.tapitDelegate retain];
    [tDel tapitInterstitialAdActionWillFinish:nil];
    [self dismissModalViewControllerAnimated:self.animated];
    [tDel tapitInterstitialAdActionDidFinish:nil];
    [tDel tapitInterstitialAdDidUnload:nil];
    [tDel release];

    //    [self dismissViewControllerAnimated:self.animated completion:^{
//        [tDel tapitInterstitialAdActionDidFinish:nil];
//        [tDel tapitInterstitialAdDidUnload:nil];
//        [tDel release];
//    }];
}

- (void)viewDidUnload
{
    self.closeButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -

- (void)dealloc
{
    self.adView = nil;
    self.closeButton = nil;
    self.tappedURL = nil;
    self.tapitDelegate = nil;
    [super dealloc];
}

@end
