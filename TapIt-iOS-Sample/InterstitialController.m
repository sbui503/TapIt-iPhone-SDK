//
//  SecondViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import "AppDelegate.h"
#import "InterstitialController.h"
#import "TapIt.h"


// This is the zone id for the Interstitial Example
// go to http://ads.tapit.com/ to get your's
//#define ZONE_ID @"7271"
#define ZONE_ID @"25079"

@interface InterstitialController ()

@end

@implementation InterstitialController

@synthesize activityIndicator;
@synthesize loadButton;
@synthesize showButton;
@synthesize interstitialAd;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLoadButton:nil];
    [self setShowButton:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark -
#pragma mark Button handling

- (IBAction)loadInterstitial:(id)sender {
    [self updateUIWithState:StateLoading];
    self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
    self.interstitialAd.delegate = self;
    self.interstitialAd.animated = YES;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:  
//                            @"test", @"mode", // enable test mode to test banner ads in your app
                            @"141298", @"cid",
                            nil];
    TapItRequest *request = [TapItRequest requestWithAdZone:ZONE_ID andCustomParameters:params];
    AppDelegate *myAppDelegate = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
    [request updateLocation:myAppDelegate.locationManager.location];
    [self.interstitialAd loadInterstitialForRequest:request];
}

- (void)updateUIWithState:(ButtonState)state {
    [loadButton setEnabled:(state != StateLoading)];
    [showButton setHidden:(state != StateReady)];
    [activityIndicator setHidden:(state != StateLoading)];
}

- (IBAction)showInterstitial:(id)sender {
    [self.interstitialAd presentFromViewController:self];
}

#pragma mark -
#pragma mark TapItInterstitialAdDelegate methods

- (void)tapitInterstitialAd:(TapItInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
    [self updateUIWithState:StateError];
}

- (void)tapitInterstitialAdDidUnload:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad did unload");
    [self updateUIWithState:StateNone];
    self.interstitialAd = nil; // don't reuse interstitial ad!
}

- (void)tapitInterstitialAdWillLoad:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad will load");
}

- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad did load");
    [self updateUIWithState:StateReady];
}

- (BOOL)tapitInterstitialAdActionShouldBegin:(TapItInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Ad action should begin");
    return YES;
}

- (void)tapitInterstitialAdActionDidFinish:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad action did finish");
}


#pragma mark -

- (void)dealloc {
    self.loadButton = nil;
    self.showButton = nil;
    self.activityIndicator = nil;
    self.interstitialAd = nil;
    [super dealloc];
}
@end
