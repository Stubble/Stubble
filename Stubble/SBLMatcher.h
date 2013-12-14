typedef BOOL(^SBLMatcherBlock)(id argument);

@interface SBLMatcher : NSObject

+ (instancetype)any;
+ (instancetype)eq:(id)obj;
+ (instancetype)refEq:(void *)obj;

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcher;

- (BOOL)matchesArgument:(id)argument;

@end
