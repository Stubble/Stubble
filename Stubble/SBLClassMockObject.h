#import "SBLMockObject.h"

#define SBLVerifyFailed @"SBLVerifyFailed"
#define SBLVerifyCalledWrongNumberOfTimes @"Expected %@ to be called %d times, but was called %d times"

@interface SBLClassMockObject : NSProxy <SBLMockObject>

- (id)initWithClass:(Class)class;
- (id)initWithProtocol:(Protocol *)protocol;

@end