#import <Foundation/Foundation.h>
#import "SBLMockObjectBehavior.h"

@interface SBLProtocolMockObjectBehavior : NSObject<SBLMockObjectBehavior>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithProtocol:(Protocol *)aProtocol;

@end
