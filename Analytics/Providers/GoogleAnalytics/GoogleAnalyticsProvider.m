// GoogleAnalyticsProvider.m
// Copyright 2013 Segment.io


#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import "AnalyticsUtils.h"
#import "Analytics.h"
#import "GoogleAnalyticsProvider.h"

@implementation GoogleAnalyticsProvider

#pragma mark - Initialization

+ (void)load {
    [Analytics registerProvider:self withIdentifier:@"Google Analytics"];
}

- (id)init {
    if (self = [super init]) {
        self.name = @"Google Analytics";
        self.valid = NO;
        self.initialized = NO;
    }
    return self;
}

- (void)start {
    // Google Analytics needs to be initialized on the main thread, but
    // dispatch-ing to the main queue when already on the main thread
    // causes the initialization to happen async. After first startup
    // we need the initialization to be synchronous.
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
        return;
    }
    // Require setup with the trackingId.
    NSString *trackingId = [self.settings objectForKey:@"mobileTrackingId"];
    [[GAI sharedInstance] trackerWithTrackingId:trackingId];
    
    // Optionally turn on uncaught exception tracking.
    NSString *reportUncaughtExceptions = [self.settings objectForKey:@"reportUncaughtExceptions"];
    if ([reportUncaughtExceptions boolValue]) {
        [GAI sharedInstance].trackUncaughtExceptions = YES;
    }
    
    // TODO: add support for sample rate
    
    // All done!
    SOLog(@"GoogleAnalyticsProvider initialized.");
}


#pragma mark - Settings

- (void)validate
{
    // All that's required is the trackingId.
    BOOL hasTrackingId = [self.settings objectForKey:@"mobileTrackingId"] != nil;
    self.valid = hasTrackingId;
}


#pragma mark - Analytics API

- (void)identify:(NSString *)userId traits:(NSDictionary *)traits options:(NSDictionary *)options
{
    // Not allowed to attach the userId in GA because it's prohibited in their terms of service.

    // We can set traits though. Iterate over all the traits and set them.
    for (NSString *key in traits) {
        [[[GAI sharedInstance] defaultTracker] set:key value:[traits objectForKey:key]];
    }
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties options:(NSDictionary *)options
{
    // Try to extract a "category" property.
    NSString *category = @"All"; // default
    NSString *categoryProperty = [properties objectForKey:@"category"];
    if (categoryProperty) {
        category = categoryProperty;
    }
    
    // Try to extract a "label" property.
    NSString *label = [properties objectForKey:@"label"];
    
    // Try to extract a "revenue" or "value" property.
    NSNumber *value = [AnalyticsProvider extractRevenue:properties];
    NSNumber *valueFallback = [AnalyticsProvider extractRevenue:properties withKey:@"value"];
    if (!value && valueFallback) {
        // fall back to the "value" property
        value = valueFallback;
    }
    
    SOLog(@"Sending to Google Analytics: category %@, action %@, label %@, value %@", category, event, label, value);
    
    // Track the event!
    [[[GAI sharedInstance] defaultTracker] send:
     [[GAIDictionaryBuilder createEventWithCategory:category
                                             action:event
                                              label:label
                                              value:value] build]];
}

- (void)screen:(NSString *)screenTitle properties:(NSDictionary *)properties options:(NSDictionary *)options
{
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:screenTitle];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

@end
