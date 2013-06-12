//
//  FirstViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import "AppDelegate.h"
#import "BannerAdController.h"
#import "TapIt.h"

// This is the zone id for the BannerAd Example
// go to http://ads.tapit.com/ to get one for your app.
//#define ZONE_ID @"7268" // for example use only, don't use this zone in your app!
#define ZONE_ID @"25078"

@implementation BannerAdController

@synthesize tapitAd;

/**
 * this is the easiest way to add banner ads to your app.
 */
- (void)initBannerSimple {
    // init banner and add to your view
    if (!tapitAd) {
        // don't re-define if we used IB to init the banner...
        tapitAd = [[TapItBannerAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [self.view addSubview:self.tapitAd];
    }

    // kick off banner rotation!
    [self.tapitAd startServingAdsForRequest:[TapItRequest requestWithAdZone:ZONE_ID]];
}

/**
 * a more advanced example that shows how to:
 * - enable ad lifecycle notifications(see TapItBannerAdViewDelegate methods section below)
 * - turn on test mode
 * - enable gps based geo-targeting
 */
- (void)initBannerAdvanced {
    // init banner and add to your view
    if (!tapitAd) {
        // don't re-define if we used IB to init the banner...
        tapitAd = [[TapItBannerAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [self.view addSubview:self.tapitAd];
    }
    
    // get notifiactions of ad lifecycle events (will load, did load, error, etc...)
    self.tapitAd.delegate = self;

    // BETA: show a loading overlay when ad is pressed
    self.tapitAd.showLoadingOverlay = YES;

    // set the parent controller for modal browser that loads when user taps ad
//    self.tapitAd.presentingController = self; // only needed if tapping banner doesn't load modal browser properly
    self.tapitAd.presentingController = self.tabBarController;
    
    // customize the request...
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"test", @"mode", // enable test mode to test banner ads in your app
                            @"141297", @"cid",
                            nil];
    TapItRequest *request = [TapItRequest requestWithAdZone:ZONE_ID andCustomParameters:params];
    
    // this is how you enable location updates... NOTE: only enable if your app has a good reason to know the users location (apple will reject your app if not)
    AppDelegate *myAppDelegate = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
    [request updateLocation:myAppDelegate.locationManager.location];
    
    // kick off banner rotation!
    [self.tapitAd startServingAdsForRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // easiest way to get banners displaying in your app...
//    [self initBannerSimple];
    
//    // - OR - the more advanced way... (use simple or advanced, but not both)
    [self initBannerAdvanced];
}

- (IBAction)hideBanner:(id)sender {
    [self.tapitAd hide];
}

- (IBAction)cancelLoad:(id)sender {
    [self.tapitAd cancelAds];
}

- (void)viewDidAppear:(BOOL)animated {
//    [self.tapitAd resume];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.tapitAd pause];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // notify banner of orientation changes
    [self.tapitAd repositionToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark TapItBannerAdViewDelegate methods

- (void)tapitBannerAdViewWillLoadAd:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner is about to check server for ad...");
}

- (void)tapitBannerAdViewDidLoadAd:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner has been loaded...");
    // Banner view will display automatically if docking is enabled
    // if disabled, you'll want to show bannerView
}

- (void)tapitBannerAdView:(TapItBannerAdView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Banner failed to load with the following error: %@", error);
    // Banner view will hide automatically if docking is enabled
    // if disabled, you'll want to hide bannerView
}

- (BOOL)tapitBannerAdViewActionShouldBegin:(TapItBannerAdView *)bannerView willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Banner was tapped, your UI will be covered up. %@", (willLeave ? @" !!LEAVING APP!!" : @""));
    // minimise app footprint for a better ad experience.
    // e.g. pause game, duck music, pause network access, reduce memory footprint, etc...
    return YES;
}

- (void)tapitBannerAdViewActionWillFinish:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner is about to be dismissed, get ready!");
    
}

- (void)tapitBannerAdViewActionDidFinish:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner is done covering your app, back to normal!");
    // resume normal app functions
}

#pragma mark -

- (void)dealloc {
    self.tapitAd = nil;
    [super dealloc];
}

@end
