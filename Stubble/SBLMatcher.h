#import "SBLHelpers.h"
#import "SBLInvocationArgument.h"

typedef BOOL(^SBLMatcherBlock)(SBLInvocationArgument *argument);

@class SBLMatcher;
typedef SBLMatcher *(^SBLMatcherPlaceholderBlock)(void);

@interface SBLMatcher : NSObject

+ (instancetype)any;
+ (instancetype)captor:(void *)captor;
+ (instancetype)objectIsEqualMatcher:(id)object;
+ (instancetype)valueIsEqualMatcher:(NSValue *)value;

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcher;

- (BOOL)isBlockPlaceholderForMatcher:(SBLMatcherPlaceholderBlock)block;
- (BOOL)matchesArgument:(SBLInvocationArgument *)argument;
- (void *)placeholder;
- (NSValue *)placeholderWithType:(char[])type;
- (void)getValue:(id *)value;

- (void)postInvocationMatchActionWithArgument:(SBLInvocationArgument *)argument;

@end
