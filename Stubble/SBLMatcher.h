@interface SBLMatcher : NSObject

+ (instancetype)any;

- (BOOL)matchesArgument:(void *)argument;

@end
