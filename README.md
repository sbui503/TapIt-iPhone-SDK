*** This branch is experimental; don't expect anything to work yet! ***
Because this is an experimental branch, you'll need to build from source, static libs aren't updated!


TapIt iOS SDK
=============

Version 3.0.0

This is the iOS SDK for the TapIt! mobile ad network.  Go to http://tapit.com/ for more details and to sign up.

***Cocos2d users go here: https://github.com/tapit/TapIt-iPhone-SDK/tree/master/cocos2d***


Usage:
------
To install, unzip the sdk archive(https://github.com/tapit/TapIt-iPhone-SDK/raw/master/dist/TapItSDK.zip) into your Xcode project.

The following frameworks are required:
````
SystemConfiguration.framework
QuartsCore.framework
CoreTelephony.framework
CoreLocation.framework - Optional *
````
*Note: CoreLocation is optional, and is used for Geo-targeting ads.  Apple mandates that your app have a good reason for enabling Location services... Apple will deny your app if location is not a core feature for your app.

**Xcode 4.5+ users should also include the following frameworks to enable support for new iOS6 features**
````
AdSupport.framework - enable support for Apple's IDFA
StoreKit.framework - enable use of SKStoreProductViewController, displays app store ads without leaving your app
````

You're all set!  Scroll down for implementation instructions.


Or, get the code:
=================
You can also compile the TapIt! SDK directly into your app.  Simply clone this repository(see intructions below), then copy the ```/Lib``` and ```/TapItSDK``` folders into your Xcode project.

This project includes JSONKit and Reachability as a git submodules.  Make sure you pull down submodules when cloning:
````
git clone --recursive https://github.com/tapit/TapIt-iPhone-SDK.git
````
-- or for older versions of git --
````
git clone https://github.com/tapit/TapIt-iPhone-SDK.git
git submodule init
git submodule update
````

AdPrompt Usage
--------------
AdPrompts are a simple ad unit designed to have a native feel.  The user is given the option to download an app, and if they accept, they are taken to app store.

````objective-c
// in your .m file
#import "TapIt.h"
...
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];
TapItAdPrompt *prompt = [[[TapItAdPrompt alloc] initWithRequest:request] autorelease];
[prompt showAsAlert];
````

For a complete example, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapIt-iOS-Sample/AdPromptDemoController.m


Banner Usage
------------
````objective-c
// in your .h file
@class TapItBannerAdView; // forward class declaration

@property (retain, nonatomic) TapItBannerAdView *tapitAd;

...

// in your .m file
#import "TapIt.h"
...
// init banner and add to your view
tapitAd = [[TapItBannerAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
[self.view addSubview:self.tapitAd];

// kick off banner rotation!
[self.tapitAd startServingAdsForRequest:[TapItRequest requestWithAdZone:@"YOUR ZONE ID"]];

...

// We don't want to show ads any more...
[self.tapitAd hide];
[self.tapitAd cancelAds];
````

For a complete example, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapIt-iOS-Sample/BannerAdController.m


Listen for location updates
---------------------------
If you want to allow for geo-targeting, listen for location updates:
````objective-c
@property (retain, nonatomic) CLLocationManager *locationManager;

...

// start listening for location updates
self.locationManager = [[CLLocationManager alloc] init];
self.locationManager.delegate = self;
[self.locationManager startMonitoringSignificantLocationChanges];

...

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // Notify the TapIt! banner when the location changes.  New location will be used the next time an ad is requested
    [self.tapitAd updateLocation:newLocation];
}

...

// Stop monitoring location when done to conserve battery life
[self.locationManager stopMonitoringSignificantLocationChanges];
````



Interstitial Usage
------------------
Show modally
````objective-c
// in your .h file
@class TapItInterstitialAd; // forward class declaration
...
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;

...

// in your .m file
#import "TapIt.h"
...
// init and load interstitial
self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
self.interstitialAd.delegate = self; // notify me of the interstitial's state changes
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];
[self.interstitialAd loadInterstitialForRequest:request];

...

- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd {
    // Ad is ready for display... show it!
    [self.interstitialAd presentFromViewController:self];
}
````
For a complete example, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapIt-iOS-Sample/InterstitialController.m

Include in paged navigation
    
````objective-c
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;

...

// init and load interstitial
self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];
[self.interstitialAd loadInterstitialForRequest:request];

...

// if interstitial is ready, show
if( self.interstitialAd.isLoaded ) {
    [self.interstitialAd presentInView:self.view];
}
````

Delegate Callbacks
------------------
TapIt! ad units follow the delegate pattern to notify your app of state changes.  For details on the delegate methods called by the TapIt! iOS SDK, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapItSDK/Headers/TapItAdDelegates.h
