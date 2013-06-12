//
//  TapItMraidDelegate.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/30/13.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    MRAID_STATE_DEFAULT,
    MRAID_STATE_LOADING,
    MRAID_STATE_RESIZED,
    MRAID_STATE_EXPANDED,
    MRAID_STATE_HIDDEN
} TapItMraidState;

typedef enum {
    MRAID_PLACEMENT_TYPE_INTERSTITIAL,
    MRAID_PLACEMENT_TYPE_INLINE
} TapItMraidPlacementType;

typedef enum {
    MRAID_FORCED_ORIENTATION_PORTRAIT,
    MRAID_FORCED_ORIENTATION_LANDSCAPE,
    MRAID_FORCED_ORIENTATION_NONE
} TapItMraidForcedOrientation;


@protocol TapItMraidDelegate <NSObject>
@required
/*
 * allow delegate to pass configuration to adview
 */
- (NSDictionary *)mraidQueryState;

/*
 * tell delegate to close the ad
 */
- (void)mraidClose;

/*
 * notify delegate of orientation properties change
 */
- (void)mraidAllowOrientationChange:(BOOL)isOrientationChangeAllowed andForceOrientation:(TapItMraidForcedOrientation)forcedOrientation;

/*
 * tell delegate to resize the ad container
 */
- (void)mraidResize:(CGRect)frame withUrl:(NSURL *)url isModal:(BOOL)isModal useCustomClose:(BOOL)useCustomClose;

/*
 * tell delegate to open link via internal browser
 */
- (void)mraidOpen:(NSString *)urlStr;

/*
 * tell delegate if it should render a close button over the ad or not
 */
- (void)mraidUseCustomCloseButton:(BOOL)useCustomCloseButton;

@optional

- (UIViewController *)mraidPresentingViewController;

@end
