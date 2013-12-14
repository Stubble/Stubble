#import "SBLMockObject.h"

#define SBLVerifyFailed @"SBLVerifyFailed"
#define SBLVerifyCalledWrongNumberOfTimes @"Expected %@ to be called %f times, but was called %f times"

@interface SBLClassMockObject : NSProxy <SBLMockObject>

- (id)initWithClass:(Class)class;

@end