#import "SBLMatcher.h"

@implementation SBLMatcher

+ (instancetype)any {
	return [[SBLMatcher alloc] init];
}

- (BOOL)matchesArgument:(void *)argument {
	return YES;
}

@end
