#import "SBLMatcher.h"

@interface SBLMatcher ()

@property (nonatomic, copy) SBLMatcherBlock matcherBlock;

@end

@implementation SBLMatcher

+ (instancetype)any {
	return [SBLMatcher matcherWithBlock:^BOOL(id argument) {
		return YES;
	}];
}

+ (instancetype)objectIsEqualMatcher:(id)object {
	return [SBLMatcher matcherWithBlock:^BOOL(id argument) {
		return [object isEqual:argument];
	}];
}

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcherBlock {
	SBLMatcher *matcher = [[SBLMatcher alloc] init];
	matcher.matcherBlock = matcherBlock;
	return matcher;
}

+ (instancetype)valueIsEqualMatcher:(NSValue *)value {
	return [SBLMatcher matcherWithBlock:^BOOL(NSValue *argument) {
		return [value isEqual:argument];
	}];
}

- (BOOL)matchesArgument:(id)argument {
	return self.matcherBlock(argument);
}

- (void *)placeholder {
	return (__bridge void *)self;
}

@end
