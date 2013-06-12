//
//  TapItMraidCommand.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/24/13.
//
//

#import <Foundation/Foundation.h>
#import "TapItAdView.h"
#import "TapItMraidDelegate.h"
#import <EventKitUI/EventKitUI.h>


@interface TapItMraidCommand : NSObject

@property(nonatomic, assign) TapItAdView *adView;

+ (NSMutableDictionary *)sharedCommandClassMap;
+ (void)registerCommand:(Class)command;
+ (id)command:(NSString *)command;
+ (NSString *)commandName;

- (void)executeWithParams:(NSDictionary *)params andDelegate:(id<TapItMraidDelegate>)delegate;

@end


@interface TapItMraidCloseCommand : TapItMraidCommand

@end


@interface TapItMraidExpandCommand : TapItMraidCommand

@end


@interface TapItMraidOpenCommand : TapItMraidCommand

@end


@interface TapItMraidCustomCloseButtonCommand : TapItMraidCommand

@end


@interface TapItMraidSetOrientationPropertiesCommand : TapItMraidCommand

@end


@interface TapItMraidLogCommand : TapItMraidCommand

@end

//@interface TapItMraidAdCalendarEvent : TapItMraidCommand <EKEventEditViewDelegate>
//@end