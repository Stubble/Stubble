typedef BOOL(^SBLMatcherBlock)(id argument);

@interface SBLMatcher : NSObject

+ (instancetype)any;
+ (instancetype)objectIsEqualMatcher:(id)object;
+ (instancetype)valueIsEqualMatcher:(NSValue *)value;

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcher;

- (BOOL)matchesArgument:(id)argument;
- (void *)placeholder;

@end
