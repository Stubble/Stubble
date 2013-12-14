#import "SBLMatcher.h"

@interface SBLMatcher ()

@property (nonatomic, copy) SBLMatcherBlock matcherBlock;

@end

@implementation SBLMatcher

+ (instancetype)any {
	return [SBLMatcher matcherWithBlock:^BOOL(void *argument) {
		return YES;
	}];
}

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcherBlock {
	SBLMatcher *matcher = [[SBLMatcher alloc] init];
	matcher.matcherBlock = matcherBlock;
	return matcher;
}

- (BOOL)matchesArgument:(void *)argument {
	return self.matcherBlock(argument);
}

- (void *)placeholder {
	return (__bridge void *)self;
}

@end
