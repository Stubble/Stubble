#import "SBLMockObject.h"

@interface SBLClassMockObject : NSProxy <SBLMockObject>

- (id)initWithClass:(Class)class;
- (id)initWithProtocol:(Protocol *)protocol;

@end