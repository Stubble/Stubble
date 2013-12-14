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

+ (instancetype)eq:(id)obj {
	SBLMatcherBlock block = nil;
	if ([obj isKindOfClass:NSObject.class]) {
		block = ^BOOL(id argument) {return [obj isEqual:argument];};
	} else {
		block = ^BOOL(id argument) {return obj == argument;};
	}
	return [self matcherWithBlock:block];
}

+ (instancetype)refEq:(void *)obj {
	return [SBLMatcher matcherWithBlock:^BOOL(id argument) {
		return obj == (__bridge void *)argument;
	}];
}

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcherBlock {
	SBLMatcher *matcher = [[SBLMatcher alloc] init];
	matcher.matcherBlock = matcherBlock;
	return matcher;
}

- (BOOL)matchesArgument:(id)argument {
	return self.matcherBlock(argument);
}

@end
