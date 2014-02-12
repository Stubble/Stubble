#import "SBLMatcher.h"

@interface SBLInvocationRecord : NSObject

@property (nonatomic, readonly) SEL selector;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithInvocation:(NSInvocation *)invocation;

- (void)setMatchers:(NSArray *)matchers;

- (BOOL)matchesInvocation:(SBLInvocationRecord *)invocationRecord;
- (const char *)returnType;


@end
