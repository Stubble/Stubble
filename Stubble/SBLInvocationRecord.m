#import "SBLInvocationRecord.h"

@interface SBLInvocationRecord ()

@property (nonatomic, readonly) NSInvocation *invocation;
@property (nonatomic) NSArray *matchers;

@end

@implementation SBLInvocationRecord

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
	if (self = [super init]) {
		[invocation retainArguments];
		_invocation = invocation;
	}
	return self;
}

typedef void(^SBLInvocationParameterEnumerationBlock)(id argument, const char *argumentType, NSUInteger index, BOOL *stop);

- (void)enumerateInvocationParameters:(NSInvocation *)invocation usingBlock:(SBLInvocationParameterEnumerationBlock)block {
    for (int i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
        // Need unsafe unretained here - http://stackoverflow.com/questions/11874056/nsinvocation-getreturnvalue-called-inside-forwardinvocation-makes-the-returned
        __unsafe_unretained id argument = nil;
        [invocation getArgument:&argument atIndex:i];
		const char *argumentType = [invocation.methodSignature getArgumentTypeAtIndex:i];
		BOOL stop = NO;
		block(argument, argumentType, i, &stop);
		if (stop) break;
    }
}

- (void)setMatchers:(NSArray *)matchers {
	// For each argument in our invocation:
	// * If it lacks a matcher use one
	//   * eq for simple type or NSObject
	//   * refEq for anything else ?
	
	__block NSMutableArray *finalMatchers = [matchers mutableCopy];
	[self enumerateInvocationParameters:self.invocation usingBlock:^(id argument, const char *argumentType, NSUInteger index, BOOL *stop) {
		if ([self typeIsObject:argumentType] || [self typeIsSimple:argumentType]) {
			SBLMatcher * __autoreleasing matcher = [SBLMatcher eq:argument];
			[self.invocation setArgument:&matcher atIndex:index];
			[finalMatchers insertObject:matcher atIndex:index-2];
		}
	}];
	
	NSLog(@"setMatchers: %p %@", self, finalMatchers);
	_matchers = finalMatchers;
}

- (BOOL)matchesInvocation:(NSInvocation *)invocation {
	__block BOOL matchingInvocation = self.invocation.selector == invocation.selector;
	if (matchingInvocation) {
		[self enumerateInvocationParameters:self.invocation usingBlock:^(id recordedArgument, const char *argumentType, NSUInteger index, BOOL *stop) {
			if ([recordedArgument isKindOfClass:SBLMatcher.class]) {
				__unsafe_unretained id argument = nil;
				[invocation getArgument:&argument atIndex:index];
				matchingInvocation &= [recordedArgument matchesArgument:argument];
			}
		}];
	}
    return matchingInvocation;
}

- (BOOL)typeIsObject:(const char *)type {
    return strcmp(type, "@") == 0;
}

- (BOOL)typeIsSimple:(const char *)type {
    return strcmp(type, "c") == 0 || strcmp(type, "i") == 0 || strcmp(type, "s") == 0 || strcmp(type, "l") == 0 || strcmp(type, "q") == 0 ||
		   strcmp(type, "C") == 0 || strcmp(type, "I") == 0 || strcmp(type, "S") == 0 || strcmp(type, "L") == 0 || strcmp(type, "Q") == 0 ||
		   strcmp(type, "f") == 0 || strcmp(type, "d") == 0 || strcmp(type, "B") == 0;
}

- (const char *)returnType {
	return self.invocation.methodSignature.methodReturnType;
}

- (NSString *)description {
	return NSStringFromSelector(self.invocation.selector);
}

@end
