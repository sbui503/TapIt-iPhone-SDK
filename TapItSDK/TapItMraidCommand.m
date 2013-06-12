//
//  TapItMraidCommand.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/24/13.
//
//

#import "TapItMraidCommand.h"
#import "TapItHelpers.h"
#import "TapItAdManager.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@implementation TapItMraidCommand
@synthesize adView;

+ (NSMutableDictionary *)sharedCommandClassMap {
    static NSMutableDictionary *sharedMap = nil;
    @synchronized(self) {
        if (!sharedMap) {
            sharedMap = [[NSMutableDictionary alloc] init];
            [sharedMap setObject:[TapItMraidExpandCommand class] forKey:[TapItMraidExpandCommand commandName]];
            [sharedMap setObject:[TapItMraidOpenCommand class] forKey:[TapItMraidOpenCommand commandName]];
            [sharedMap setObject:[TapItMraidCloseCommand class] forKey:[TapItMraidCloseCommand commandName]];
            [sharedMap setObject:[TapItMraidCustomCloseButtonCommand class] forKey:[TapItMraidCustomCloseButtonCommand commandName]];
            [sharedMap setObject:[TapItMraidSetOrientationPropertiesCommand class] forKey:[TapItMraidSetOrientationPropertiesCommand commandName]];
            [sharedMap setObject:[TapItMraidLogCommand class] forKey:[TapItMraidLogCommand commandName]];
        }
    }
    return sharedMap;
}

+ (void)registerCommand:(Class)command {
    NSMutableDictionary *map = [self sharedCommandClassMap];
    @synchronized(self) {
        [map setValue:command forKey:[command commandName]];
    }
}

+ (id)command:(NSString *)command {
    NSMutableDictionary *map = [self sharedCommandClassMap];
    @synchronized(self) {
        Class klass = [map objectForKey:command];
        return [[[klass alloc] init] autorelease];
    }
}

+ (NSString *)commandName {
    return @"";
}

- (void)executeWithParams:(NSDictionary *)params andDelegate:(id<TapItMraidDelegate>)delegate {
}

@end


/**********************************************************************
 **********************************************************************/
@implementation TapItMraidCloseCommand

+ (NSString *)commandName {
    return @"close";
}

- (void)executeWithParams:(NSDictionary *)params andDelegate:(id<TapItMraidDelegate>)delegate {
    NSLog(@"MRAID CLOSE");
    
    [delegate mraidClose];
}

@end


/**********************************************************************
 **********************************************************************/
@implementation TapItMraidExpandCommand

+ (NSString *)commandName {
    return @"expand";
}

- (void)executeWithParams:(NSDictionary *)params andDelegate:(id<TapItMraidDelegate>)delegate {
    NSLog(@"expanding! %@", params);
    NSString *urlStr = [params objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    CGRect applicationFrame = TapItApplicationFrame(TapItInterfaceOrientation());
    CGFloat appWidth = CGRectGetWidth(applicationFrame);
    CGFloat appHeight = CGRectGetHeight(applicationFrame);
    
    CGFloat w = CGFLOAT_MAX;
    NSNumber *tmp = [params objectForKey:@"w"];
    if (tmp) {
        w = [tmp floatValue];
    }
    w = MIN(w, appWidth);
    
    CGFloat h = CGFLOAT_MAX;
    tmp = [params objectForKey:@"h"];
    if (tmp) {
        h = [tmp floatValue];
    }
    h = MIN(h, appHeight);
    
    // Center the ad within the application frame.
    CGFloat x = applicationFrame.origin.x + floor((appWidth - w) / 2);
    CGFloat y = applicationFrame.origin.y + floor((appHeight - h) / 2);

    CGRect frame = CGRectMake(x, y, w, h);

    tmp = [params objectForKey:@"isModal"];
    BOOL isModal = tmp ? [tmp boolValue] : YES;
    tmp = [params objectForKey:@"useCustomClose"];
    BOOL useCustomClose = tmp ? [tmp boolValue] : NO;
    [delegate mraidResize:frame withUrl:url isModal:isModal useCustomClose:useCustomClose];
}

@end


/**********************************************************************
 **********************************************************************/
@implementation TapItMraidOpenCommand

+ (NSString *)commandName {
    return @"open";
}

- (void)executeWithParams:(NSDictionary *)params andDelegate:(id<TapItMraidDelegate>)delegate {
    NSString *url = [params objectForKey:@"url"];
    NSLog(@"MRAID open: %@", url);
    [delegate mraidOpen:url];
}

@end


/**********************************************************************
 **********************************************************************/
@implementation TapItMraidCustomCloseButtonCommand

+ (NSString *)commandName {
    return @"useCustomClose";
}

- (void)executeWithParams:(NSDictionary *)params andDelegate:(id<TapItMraidDelegate>)delegate {
    BOOL useCustomClose = [(NSNumber *)[params objectForKey:@"useCustomClose"] boolValue];
    [delegate mraidUseCustomCloseButton:useCustomClose];
}

@end


/**********************************************************************
 **********************************************************************/
@implementation TapItMraidSetOrientationPropertiesCommand

+ (NSString *)commandName {
    return @"setOrientationProperties";
}

- (void)executeWithParams:(NSDictionary *)params andDelegate:(id<TapItMraidDelegate>)delegate {
    BOOL allowOrientationChange = YES;
    TapItMraidForcedOrientation forcedOrientation = MRAID_FORCED_ORIENTATION_NONE;
    [delegate mraidAllowOrientationChange:allowOrientationChange andForceOrientation:forcedOrientation];
}

@end


/**********************************************************************
 **********************************************************************/
@implementation TapItMraidLogCommand

+ (NSString *)commandName {
    return @"log";
}

- (void)executeWithParams:(NSDictionary *)params andDelegate:(id<TapItMraidDelegate>)delegate {
    NSString *msg = [params objectForKey:@"message"];
    NSLog(@"MRAID LOG: %@", msg);
}

@end


/**********************************************************************
*/

//@implementation TapItMraidAdCalendarEvent
//
//+ (NSString *)commandName {
//    return @"addCalendarEvent";
//}
//
//- (void)executeWithParams:(NSDictionary *)params andDelegate:(id<TapItMraidDelegate>)delegate {
//    // {description: "Mayan Apocalypse/End of World", location: "everywhere", start: "2012-12-21T00:00-05:00", end: "2012-12-22T00:00-05:00"}
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
//
////    // RFC3339 date formatting
////    NSString *dateString = @"2011-03-24T10:00:00-08:00";
////    
////    NSDate *date;
////    NSError *error = nil;
////    BOOL success = [formatter getObjectValue:&date forString:dateString range:nil error:&error];
////    if (!success) {
////        NSLog(@"Error occured while parsing date: %@", error);
////    }
////    NSLog(@"NSDate from string: %@", date);
////    
////    
////    return;
//
//    
//    
//    EKEventStore *_eventStore = [[EKEventStore alloc] init];
//
//    void (^storeEvent)();
//    storeEvent = ^(void){
//        EKCalendar *defaultEventStore = [_eventStore defaultCalendarForNewEvents];
//        
//        NSLog(@"event store details: %@", defaultEventStore.description);
//        
//        EKCalendar *defaultCalendar = [_eventStore defaultCalendarForNewEvents];
//        
//        // Create a new event... save and commit
//        NSError *error = nil;
//        EKEvent *myEvent = [EKEvent eventWithEventStore:_eventStore];
//        myEvent.allDay = NO;
//        myEvent.startDate = [NSDate date];
//        myEvent.endDate = [NSDate date];
//        myEvent.title = @"MRAID Calendar Event Test";
//        myEvent.calendar = defaultCalendar;
//        [myEvent addAlarm:[EKAlarm alarmWithRelativeOffset:5]];
//        
//        EKEventEditViewController *vc = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
//        vc.event = myEvent;
//        vc.eventStore = _eventStore;
////        vc.allowsEditing = NO;
//        vc.editViewDelegate = self;
//        
//        [[delegate mraidPresentingViewController] presentModalViewController:vc animated:NO];
//        [vc release];
//        
//        return;
//        [_eventStore saveEvent:myEvent span:EKSpanThisEvent commit:YES error:&error];
//        
//        if (!error) {
//            NSLog(@"the event saved and committed correctly with identifier %@", myEvent.eventIdentifier);
//        } else {
//            NSLog(@"there was an error saving and committing the event");
//            error = nil;
//        }
//        
//        EKEvent *savedEvent = [_eventStore eventWithIdentifier:myEvent.eventIdentifier];
//        NSLog(@"saved event description: %@",savedEvent);
//    };
//    
//    if ([_eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
//        [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//            if (error) {
//                //TODO fire off error event to JS
//                NSLog(@"error! %@", error);
//            }
//            else if (!granted) {
//                //TODO fire off no permissions error to JS
//                NSLog(@"not granted!");
//            }
//            else {
//                dispatch_async(dispatch_get_main_queue(), storeEvent);
//            }
//        }];
//        
//    }
//    else {
//        NSLog(@"the old way...");
//        storeEvent();
//    }
//    
//    [formatter release];
//    [_eventStore release];
//}
//
//- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
//    switch (action) {
//        case EKEventEditViewActionCancelled:
//            NSLog(@"cancelled");
//            break;
//        case EKEventEditViewActionDeleted:
//            NSLog(@"deleted");
//            break;
//        case EKEventEditViewActionSaved:
//            NSLog(@"saved");
//
//            NSError *error = nil;
//            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent commit:YES error:&error];
//            
//            if (!error) {
//                NSLog(@"the event saved and committed correctly with identifier %@", controller.event.eventIdentifier);
//            } else {
//                NSLog(@"there was an error saving and committing the event");
//                error = nil;
//            }
//            
//            EKEvent *savedEvent = [controller.eventStore eventWithIdentifier:controller.event.eventIdentifier];
//            
//            break;
//        default:
//            break;
//    }
//    [controller dismissModalViewControllerAnimated:YES];
//    NSLog(@"eventEditViewController:didCompleteWithAction:");
//}
//@end

