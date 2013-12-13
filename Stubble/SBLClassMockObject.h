#import "SBLMockObject.h"

#define SBLVerifyFailed @"SBLVerifyFailed"

@interface SBLClassMockObject : NSProxy <SBLMockObject>

- (id)initWithClass:(Class)class;

@end