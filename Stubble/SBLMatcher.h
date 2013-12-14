typedef BOOL(^SBLMatcherBlock)(void *argument);

@interface SBLMatcher : NSObject

+ (instancetype)any;

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcher;

- (BOOL)matchesArgument:(void *)argument;
- (void *)placeholder;

@end
