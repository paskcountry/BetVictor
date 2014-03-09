//
//  TweetsReachability.h
//  MapTweets
//
//  Created by cash on 09/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface TweetsReachability : NSObject

- (BOOL)isInternetReachable;

typedef enum {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;

@end
