//
//  AppDelegate.m
//  TestAppIOS
//
//  Created by Tony Xiao on 8/17/13.
//  Copyright (c) 2013 Segment.io. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Analytics debug:YES];
    NSDictionary *settings = @{@"Mixpanel" : @{@"token" : @"89f86c4aa2ce5b74cb47eb5ec95ad1f9"}};
    [Analytics initializeWithSettings:settings];
    //[[Analytics sharedAnalytics] identify:nil];
    [[Analytics sharedAnalytics] track:@"Anonymous Event"];
    [[Analytics sharedAnalytics] identify:@"Test User"];
    [[Analytics sharedAnalytics] track:@"Logged In Event"];
    return YES;
}
    
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[Analytics sharedAnalytics] track:@"Background Event"];
}

@end
