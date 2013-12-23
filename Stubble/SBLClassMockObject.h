#import "SBLMockObject.h"

#define SBLVerifyFailed @"SBLVerifyFailed"
#define SBLVerifyCalledWrongNumberOfTimes @"Expected %@ to be called %ld times, but was called %ld times"

@interface SBLClassMockObject : NSProxy <SBLMockObject>

- (id)initWithClass:(Class)class;
- (id)initWithProtocol:(Protocol *)protocol;

@end