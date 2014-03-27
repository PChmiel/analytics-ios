// SambaProvider.h
// Copyright 2014 Samba TV

#import <Foundation/Foundation.h>
#import "AnalyticsProvider.h"

extern NSString *const SambaDidSendRequestNotification;
extern NSString *const SambaRequestDidSucceedNotification;
extern NSString *const SambaRequestDidFailNotification;

@interface SambaProvider : AnalyticsProvider <AnalyticsProvider>

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *sessionId;
@property(nonatomic, assign) NSUInteger flushAt;
@property(nonatomic, assign) NSUInteger flushAfter;



// Analytics API
// -------------

- (void)identify:(NSString *)userId traits:(NSDictionary *)traits options:(NSDictionary *)options;
- (void)track:(NSString *)event properties:(NSDictionary *)properties options:(NSDictionary *)options;
- (void)screen:(NSString *)screenTitle properties:(NSDictionary *)properties options:(NSDictionary *)options;
- (void)discoverDevices:(NSString *)sambaDeviceId devices:(NSDictionary *)discoveredDevices options:(NSDictionary *)options;

// Utilities
// ---------

- (NSString *)getSessionId;
- (void)flush;
- (void)reset;

// Initialization
// --------------

- (id)initWithFlushAt:(NSUInteger)flushAt flushAfter:(NSUInteger)flushAfter;

@end