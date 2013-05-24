//
//  TapItPrivateConstants.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#ifndef TapIt_iOS_Sample_TapItPrivateConstants_h
#define TapIt_iOS_Sample_TapItPrivateConstants_h

#import "TapItConstants.h"
#import "TapItHelpers.h"


#define TAPIT_REPORTING_SERVER_URL                          @"http://a.tapit.com"
//#define TAPIT_AD_SERVER_BASE_URL                            @"http://r.tapit.com"
#define TAPIT_AD_SERVER_BASE_URL                            @"http://dev.tapit.com/~npenteado"
#define TAPIT_AD_SERVER_URL                                 [NSString stringWithFormat:@"%@/adrequest.php", TAPIT_AD_SERVER_BASE_URL]
#define TAPIT_CLICK_SERVER_BASE_URL                         @"http://c.tapit.com"

#define TAPIT_PARAM_VALUE_BANNER_ROTATE_INTERVAL            120
#define TAPIT_PARAM_VALUE_BANNER_ERROR_TIMEOUT_INTERVAL     30

#define TAPIT_AD_TYPE_BANNER @"1"
#define TAPIT_AD_TYPE_INTERSTITIAL @"2"
#define TAPIT_AD_TYPE_ALERT @"10"


#endif
