#import "ESCallDetection.h"
#import <CallKit/CallKit.h>

/**
 * Detects an active call through CallKit's CXCallObserver, which reports every call the system
 * knows about: cellular calls and VoIP calls of apps that integrate with CallKit (FaceTime,
 * WhatsApp, ...). No permission and no entitlement is required, and no metadata about the
 * call or the caller is exposed. This is a strong signal, not proof: VoIP apps that do not use
 * CallKit are invisible.
 */
@interface ESCallDetection ()
@property (strong, nonatomic) CXCallObserver *callObserver;
@end

@implementation ESCallDetection

- (instancetype)initWithObjectId:(NSString *)objectId properties:(NSDictionary *)properties inContext:(id<TabrisContext>)context {
    self = [super initWithObjectId:objectId properties:properties inContext:context];
    if (self) {
        self.callObserver = [[CXCallObserver alloc] init];
    }
    return self;
}

- (void)destroy {
    self.callObserver = nil;
    [super destroy];
}

+ (NSString *)remoteObjectType {
    return @"com.eclipsesource.calldetection.CallDetection";
}

+ (NSMutableSet *)remoteObjectProperties {
    NSMutableSet *properties = [super remoteObjectProperties];
    [properties addObject:@"inCall"];
    return properties;
}

// No UI.
- (UIView *)view {
    return nil;
}

// A call counts from the moment it is dialed or starts ringing until it has ended.
- (BOOL)inCall {
    for (CXCall *call in self.callObserver.calls) {
        if (!call.hasEnded) {
            return YES;
        }
    }
    return NO;
}

@end
