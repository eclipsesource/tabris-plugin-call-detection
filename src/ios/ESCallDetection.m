#import "ESCallDetection.h"

@implementation ESCallDetection

- (instancetype)initWithObjectId:(NSString *)objectId properties:(NSDictionary *)properties inContext:(id<TabrisContext>)context {
    self = [super initWithObjectId:objectId properties:properties inContext:context];
    return self;
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

// Skeleton step: a random value proves that the JS <-> native wiring works.
// Real detection (CXCallObserver) replaces this in the next step.
- (BOOL)inCall {
    return arc4random_uniform(2) == 1;
}

@end
