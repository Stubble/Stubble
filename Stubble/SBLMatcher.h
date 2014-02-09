#import "SBLHelpers.h"

@class SBLMatcher;
typedef BOOL(^SBLMatcherBlock)(id argument, BOOL shouldUnboxArgument);
typedef SBLMatcher *(^SBLMatcherPlaceholderBlock)(void);

@interface SBLMatcher : NSObject

+ (instancetype)any;
+ (instancetype)captor:(void *)captor;
+ (instancetype)objectIsEqualMatcher:(id)object;
+ (instancetype)valueIsEqualMatcher:(NSValue *)value;

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcher;

- (BOOL)isBlockPlaceholderForMatcher:(SBLMatcherPlaceholderBlock)block;
- (BOOL)matchesArgument:(id)argument shouldUnboxArgument:(BOOL)shouldUnboxArgument;
- (void *)placeholder;
- (NSValue *)placeholderWithType:(char[])type;
- (void)getValue:(id *)value;

@end
