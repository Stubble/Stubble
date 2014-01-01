#import "SBLMockObject.h"

@interface SBLStandardMockObject : NSProxy <SBLMockObject>

- (id)initWithClass:(Class)class;
- (id)initWithProtocol:(Protocol *)protocol;

@end