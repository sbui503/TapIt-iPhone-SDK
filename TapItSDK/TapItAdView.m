//
//  TapItAdView.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import "TapItAdView.h"
#import "TapItPrivateConstants.h"
#import "TapItMraidCommand.h"

@implementation TapItAdView

@synthesize tapitRequest, tapitDelegate, isLoaded, wasAdActionShouldBeginMessageFired, interceptPageLoads;
@synthesize isMRAID, mraidDelegate, mraidState;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setScrollable:NO];
        self.delegate = self; // UIWebViewDelegate
        self.isLoaded = NO;
        self.interceptPageLoads = YES;
        self.mraidState = @"loading";
        
        if ([self respondsToSelector:@selector(setAllowsInlineMediaPlayback:)]) {
            [self setAllowsInlineMediaPlayback:YES];
        }

        if ([self respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
            [self setMediaPlaybackRequiresUserAction:NO];
        }
    }
    return self;
}

- (void)setScrollable:(BOOL)scrollable {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000 // iOS 5.0+
    if ([self respondsToSelector:@selector(scrollView)])
    {
        UIScrollView *scrollView = self.scrollView;
        scrollView.scrollEnabled = scrollable;
        scrollView.bounces = scrollable;
    } 
    else 
#endif
    {
        UIScrollView *scrollView = nil;
        for (UIView *v in self.subviews)
        {
            if ([v isKindOfClass:[UIScrollView class]])
            {
                scrollView = (UIScrollView *)v;
                break;
            }
        }
        scrollView.scrollEnabled = scrollable;
        scrollView.bounces = scrollable;
    }
}

- (void)loadData:(NSDictionary *)adData {
    NSString *adWidth = [NSString stringWithString:[adData objectForKey:@"adWidth"]];

    NSString *width = [NSString stringWithFormat:@"width:%@px; margin:0 auto; text-align:center", adWidth];
    NSString *adHtml = [NSString stringWithString:[adData objectForKey:@"html"]];
    NSRange range = [adHtml rangeOfString:@"mraid.js" options:NSCaseInsensitiveSearch];
//    NSString *mraidHtml;
    if (range.location != NSNotFound) {
        //TODO enable mraid mode!
//        mraidHtml = @"<script type=\"text/javascript\">var mraid = {getState: function() { return \"loading\"}, addEventListener: function(state, callback){}};</script>";
        self.isMRAID = YES;
        self.interceptPageLoads = NO;
    }
    else {
//        mraidHtml = @"";
        self.isMRAID = NO;
    }
    NSLog(@"MRAID is %@", (self.isMRAID ? @"ON" : @"OFF"));
    NSString *htmlData = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">body {margin:0; padding:0;}</style></head><body><div style=\"%@\">%@</div></body></html>", width, adHtml];
    NSLog(@"HTML: %@", htmlData);
    NSURL *baseUrl = [NSURL URLWithString:TAPIT_AD_SERVER_BASE_URL];
    NSLog(@"BaseURL: %@", baseUrl);
    [super loadHTMLString:htmlData baseURL:baseUrl];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"webViewDidStartLoad: %@", webView);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad: %@", webView);
    if(!self.isLoaded || self.interceptPageLoads) {
        [self.tapitDelegate didLoadAdView:self];
    }
    self.isLoaded = YES;
    self.mraidState = @"default";
    [self syncMraidState];
    [self fireMraidEvent:@"stateChange" withParams:self.mraidState];
    [self fireMraidEvent:@"ready" withParams:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // Ignore NSURLErrorDomain error -999.
    if (error.code == NSURLErrorCancelled) {
        return;   
    }
    
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) {
        return; 
    }

    [self.tapitDelegate adView:self didFailToReceiveAdWithError:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (self.isMRAID && [request.URL.absoluteString hasPrefix:@"nativecall://"]) {
        [self handleNativeCall:request.URL.absoluteURL];
        return NO;
    }

    NSLog(@"shouldStartLoadWithRequest: %@", request.URL.absoluteURL);

    if ([request.URL.absoluteString hasPrefix:@"applewebdata://"]) {
        NSLog(@"Allowing applewebdata: %@", request.URL);
        return YES;
    }
    else {
        if (!([request.URL.absoluteString hasPrefix:@"http://"] || [request.URL.absoluteString hasPrefix:@"https://"])) {
            if ([[UIApplication sharedApplication] canOpenURL:request.URL])
            {
                [self.tapitDelegate adActionShouldBegin:request.URL willLeaveApplication:YES];
                [[UIApplication sharedApplication] openURL:request.URL];
                return NO;
            }
            else {
                NSLog(@"OS says it can't handle request scheme: %@", request.URL);
            }
        }
        
        if (!self.interceptPageLoads || !self.isLoaded) {
            NSLog(@"Not intercepting page loads... proceed");
            // first time loading, let the ad load
            return YES;
        }

        BOOL shouldLeaveApp = NO; //TODO: figure how to answer this correctly, while taking into account redirects...
        //TODO figure out how to stop this from getting fired for each redirect!!!
        BOOL shouldLoad = [self.tapitDelegate adActionShouldBegin:request.URL willLeaveApplication:shouldLeaveApp];
        if(!shouldLoad) {
//            NSLog(@"Canceling");
        }
        return shouldLoad;
    }
}

#pragma mark -
#pragma mark MRAID

- (void)didResize:(BOOL)isModal {
    if (self.isMRAID) {
        [self fireMraidEvent:@"stateChanged" withParams:self.mraidState];
    }
}

- (void)syncMraidState {
    // pass over isVisible, placement type, state, max size, screen size, current position
    
    NSDictionary *containerState = [self.mraidDelegate mraidQueryState];
    NSString *placementType = [containerState objectForKey:@"placementType"];
    
    NSNumber *height = [NSNumber numberWithFloat:self.frame.size.height];
    NSNumber *width = [NSNumber numberWithFloat:self.frame.size.width];
    NSDictionary *state = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:!self.isHidden], @"isVisible",
                           self.mraidState, @"state",
                           height, @"height",
                           width, @"width",
                           @0, @"x", //TODO get ad frame...
                           @0, @"y",
                           
                           placementType, @"placementType",
                           nil];
    NSLog(@"Syncing this state: %@", state);
    
    // tell JS about changes...
    [self mraidResponse:state withCallbackToken:nil];
}


- (void)setIsVisible:(BOOL)visible {
    _isVisible = visible;
    
    if (self.isMRAID) {
        [self fireMraidEvent:@"viewableChange" withParams:@"[true]"];
        [self syncMraidState];
    }
}

- (void)handleNativeCall:(NSURL *)url {
    NSString *commandStr = url.host;
//    NSDictionary *params = url.
    
    NSString * q = [url query];
    NSArray * pairs = [q componentsSeparatedByString:@"&"];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    for (NSString * pair in pairs) {
        NSArray * bits = [pair componentsSeparatedByString:@"="];
        NSString * key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:value forKey:key];
    }

    if (![@"log" isEqualToString:commandStr]) {
        NSLog(@"Native call: %@", url);
        NSLog(@"%@", commandStr);
        NSLog(@"%@", params);
    }
    
    //TODO dispatch command
    TapItMraidCommand *command = [TapItMraidCommand command:commandStr];
    command.adView = self;
    
    [command executeWithParams:params andDelegate:self.mraidDelegate];
    if (![@"log" isEqualToString:commandStr]) {
        [self syncMraidState];
    }
}

- (void)fireMraidEvent:(NSString *)eventName withParams:(NSString *)jsonString {
    NSString *eventString;
    if (jsonString && ![jsonString hasPrefix:@"["]) {
        jsonString = [NSString stringWithFormat:@"[\"%@\"]", jsonString];
    }

    if (jsonString) {
        eventString = [NSString stringWithFormat:@"{name:\"%@\", props:%@}", eventName, jsonString];
    }
    else {
        eventString = [NSString stringWithFormat:@"{name:\"%@\"}", eventName];
    }
    NSLog(@"Firing MRAID Event: %@", eventString);
    [self mraidResponse:@{@"_fire_event_": eventString} withCallbackToken:nil];
}

- (void)mraidResponse:(NSDictionary *)resposeData withCallbackToken:(NSString *)callbackToken {
    NSMutableString *dataJson = [NSMutableString stringWithString:@"{"];
    BOOL __block first = YES;
    [resposeData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(!first) {
            [dataJson appendString:@","];
        }
        else {
            first = NO;
        }
        if([obj isKindOfClass:[NSString class]] && ![obj hasPrefix:@"{"] && ![obj hasPrefix:@"["]) {
            [dataJson appendFormat:@"%@:\"%@\"", key, obj];
        }
        else {
            [dataJson appendFormat:@"%@:%@", key, obj];
        }
    }];
    
    [dataJson appendString:@"}"];
    
    NSString *js;
    if(callbackToken) {
        // responding to a live request
        js = [NSString stringWithFormat:@"mraid._nativeResponse(%@,\"%@\");", dataJson, callbackToken];
    }
    else {
        // syncing data down to js
        js = [NSString stringWithFormat:@"mraid._nativeResponse(%@);", dataJson];
    }
    NSLog(@"nativeResponse: %@", js);
    [self stringByEvaluatingJavaScriptFromString:js];
}

- (void)repositionToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (self.isMRAID) {
        CGFloat angle = 0.0;
        NSInteger deg = 0;
        if (UIInterfaceOrientationIsPortrait(orientation) ||
            UIInterfaceOrientationIsLandscape(orientation)) {
            switch (orientation) {
                case UIInterfaceOrientationPortrait:
                    // 0.0
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    angle = -M_PI_2;
                    deg = 90;
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    angle = M_PI_2;
                    deg = -90;
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    angle = M_PI;
                    deg = 180;
                    break;
                default:
                    // 0.0
                    break;
            }
        
            self.transform = CGAffineTransformMakeRotation(angle);

            if([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] == NSOrderedAscending) {
                // device is < v5.0, manually fire JS orientation updates
                NSString *javascript = [NSString stringWithFormat:
                                        @"window.__defineGetter__('orientation',function(){return %i;});"
                                        @"function(){var event = document.createEvent('Events');"
                                        @"event.initEvent('orientationchange', true, false);"
                                        @"window.dispatchEvent(event);"
                                        @"})();",
                                        deg];
                [self stringByEvaluatingJavaScriptFromString:javascript];
            }
        }
        
        
        // fire size change
        CGRect frame = TapItApplicationFrame(orientation);
        NSString *params = [NSString stringWithFormat:@"[%i, %i]", (int)frame.size.width, (int)frame.size.height];
        if ([@"expanded" isEqualToString:self.mraidState]) {
            // resize the adview
            self.superview.frame = frame;
            self.bounds = CGRectMake(0,0,frame.size.width,frame.size.height);
        }
        [self fireMraidEvent:@"sizeChange" withParams:params];
    }
}

#pragma mark -

- (void)dealloc {
    [tapitRequest release], tapitRequest = nil;
    [super dealloc];
}

@end
