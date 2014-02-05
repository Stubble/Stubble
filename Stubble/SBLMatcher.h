typedef BOOL(^SBLMatcherBlock)(id argument, BOOL shouldUnboxArgument);

@interface SBLMatcher : NSObject

+ (instancetype)any;
+ (instancetype)captor:(void *)captor;
+ (instancetype)objectIsEqualMatcher:(id)object;
+ (instancetype)valueIsEqualMatcher:(NSValue *)value;

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcher;

- (BOOL)matchesArgument:(id)argument shouldUnboxArgument:(BOOL)shouldUnboxArgument;
- (void *)placeholder;
- (NSValue *)placeholderWithType:(char[])type;

@end
