//
//  VideoAdController.h
//  TapIt-iOS-Sample
//
//  Sample view controller showcasing TapIt's Video Ad SDK.
//
//  Created by Kevin Truong on 4/22/13.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CMTime.h>
#import <UIKit/UIKit.h>

#import "TRMAAdsRequest.h"
#import "TRMAVideoAdsManager.h"
#import "TRMAAdsLoader.h"
#import "TRMAClickTrackingUIView.h"
#import "TRMAClickThroughBrowser.h"

#import "FullScreenVC.h"

@interface VideoAdController : UIViewController<TRMAAdsLoaderDelegate,
            TRMAClickTrackingUIViewDelegate, TRMAVideoAdsManagerDelegate,
            TRMAClickThroughBrowserDelegate>

// The loader of ads.
@property(nonatomic, retain) TRMAAdsLoader *adsLoader;
// The manager of video ads.
@property(nonatomic, retain) TRMAVideoAdsManager *videoAdsManager;
// The invisible view that tracks clicks on the video.
@property(nonatomic, retain) TRMAClickTrackingUIView *clickTrackingView;

@property (nonatomic, retain) AVPlayer              *contentPlayer;
@property (nonatomic, retain) AVPlayer              *adPlayer;
@property (nonatomic, retain) AVPlayer              *playingPlayer;
@property (nonatomic, retain) UIView                *adView;
@property (nonatomic, assign) id                    playHeadObserver;
@property (nonatomic, assign) BOOL                  isVideoSkippable;
@property (nonatomic, retain) FullScreenVC          *landscapeVC;
@property (nonatomic, retain) UIImage               *playButtonImage;
@property (nonatomic, retain) UIImage               *pauseButtonImage;

@property (nonatomic, retain) IBOutlet UIButton     *adRequestButton;
@property (nonatomic, retain) IBOutlet UIButton     *resetButton;
@property (nonatomic, retain) IBOutlet UISwitch     *browserSwitch;
@property (nonatomic, retain) IBOutlet UIView       *videoView;
@property (nonatomic, retain) IBOutlet UIButton     *playHeadButton;
@property (nonatomic, retain) IBOutlet UITextField  *playTimeText;
@property (nonatomic, retain) IBOutlet UITextField  *durationText;
@property (nonatomic, retain) IBOutlet UISlider     *progressBar;
@property (nonatomic, retain) IBOutlet UITextView   *console;
@property (nonatomic, retain) IBOutlet UISwitch     *maximizeSwitch;

- (IBAction)onPlayPauseClicked:(id)sender;
- (IBAction)playHeadValueChanged:(id)sender;
- (IBAction)onRequestAds;
- (IBAction)onUnloadAds;
- (IBAction)onResetState;


@end
