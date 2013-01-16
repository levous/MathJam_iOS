//
//  Constants.h
//  MathJam
//
//  Created by Rusty Zarse on 11/2/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#define kRZ_LOG_ANALYTICS_EVENT_NOTIFICATION_NAME @"LogAnalyticsEvent"
#define kRZ_LOG_ANALYTICS_NOTIFICATION_DATA_KEY @"AnalyticsData"

#define kRZ_DEFAULT_FONT_NAME @"ChalkboardSE-Regular"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
