//
//  AppDelegate.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

//// Include this file in your App Delegate if you're not using AdMob,
//// but are getting AdMob related errors during compile time
//#import "TapItAdMobStubs.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) CLLocationManager *locationManager;

@end
