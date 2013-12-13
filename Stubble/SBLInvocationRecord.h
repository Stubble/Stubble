#import "SBLMatcher.h"

@interface SBLInvocationRecord : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithInvocation:(NSInvocation *)invocation;

- (void)setMatchers:(NSArray *)matchers;

- (BOOL)matchesInvocation:(NSInvocation *)invocation;
- (const char *)returnType;


@end
