#import "SBLMatcher.h"

@class SBLInvocationMatchResult;

@interface SBLInvocationRecord : NSObject

@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly) long callOrder;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithInvocation:(NSInvocation *)invocation;

- (void)setMatchers:(NSArray *)matchers;

- (SBLInvocationMatchResult *)matchResultForInvocation:(SBLInvocationRecord *)invocationRecord;
- (const char *)returnType;


@end
