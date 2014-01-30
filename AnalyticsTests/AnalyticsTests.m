//
//  AnalyticsTests.m
//  AnalyticsTests
//
//  Created by Tony Xiao on 8/23/13.
//  Copyright (c) 2013 Segment.io. All rights reserved.
//

#import "Analytics.h"
#import "AnalyticsUtils.h"
#import "KWNotificationMatcher.h"
#import "Reachability.h"

@interface Analytics (Private)
@property (nonatomic, strong) NSDictionary *cachedSettings;
@end

SPEC_BEGIN(AnalyticsTests)

describe(@"Analytics", ^{
    SetShowDebugLogs(YES);
    __block Analytics *analytics = nil;
    
    [Reachability reachabilityWithHostname:@"www.google.com"];
    
    beforeEach(^{
        NSDictionary *settings = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:
                                                   [[NSBundle bundleForClass:[self class]]
                                                    URLForResource:@"settings" withExtension:@"json"]] options:NSJSONReadingMutableContainers error:NULL];
        analytics = [[Analytics alloc] initWithSettings:settings];
    });
    
    it(@"has 9 providers", ^{
        [[[analytics should] have:9] providers];
    });
    
    it(@"Should identify", ^{
        NSString *userId = @"smile@wrinkledhippo.com";
        NSDictionary *traits = @{@"Filter": @"Tilt-shift", @"HasFriends": @YES, @"FriendCount" : @233 };
        NSDictionary *options = @{@"providers": @{@"Salesforce": @YES, @"HubSpot": @NO}};
        [analytics identify:userId traits:traits options:options];

    });
    
    it(@"Should gracefully handle nil userId", ^{
        [analytics identify:nil traits:nil options:nil];

    });
    
    it(@"Should track", ^{
        NSString *eventName = @"Purchased an iMac";
        NSDictionary *properties = @{
            @"Filter": @"Tilt-shift",
            @"category": @"Mobile",
            @"revenue": @"70.0",
            @"value": @"50.0",
            @"label": @"gooooga"
        };
        NSDictionary *options = @{@"providers": @{@"Salesforce": @YES, @"HubSpot": @NO}};
        [analytics track:eventName properties:properties options:options];

    });
    
    it(@"Should track according to providers options", ^{
        NSString *eventName = @"Purchased an iMac but not Mixpanel";
        NSDictionary *properties = @{
                                     @"Filter": @"Tilt-shift",
                                     @"category": @"Mobile",
                                     @"revenue": @"70.0",
                                     @"value": @"50.0",
                                     @"label": @"gooooga"
                                     };
        NSDictionary *options = @{@"providers": @{@"Mixpanel": @NO}};
        [analytics track:eventName properties:properties options:options];
    });
    
});

SPEC_END