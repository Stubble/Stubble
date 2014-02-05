#import "SBLInvocationRecord.h"
#import "SBLErrors.h"
#import "SBLHelpers.h"

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

- (SEL)selector {
	return self.invocation.selector;
}

- (NSValue *)boxedValueForArgumentIndex:(NSInteger)index inInvocation:(NSInvocation *)invocation {
	const char *argumentType = [invocation.methodSignature getArgumentTypeAtIndex:index];
	BOOL isStruct = argumentType[0] == '{';
	NSValue *boxedArgument = nil;
	if (isStruct) {
		NSUInteger typeSize = 0;
		NSGetSizeAndAlignment(argumentType, &typeSize, NULL);
		NSMutableData *argumentData = [[NSMutableData alloc] initWithLength:typeSize];
		[invocation getArgument:[argumentData mutableBytes] atIndex:index];
		boxedArgument = [NSValue valueWithBytes:[argumentData bytes] objCType:argumentType];
	} else {
		__unsafe_unretained id argument = nil;
		[invocation getArgument:&argument atIndex:index];
		boxedArgument = [NSValue valueWithBytes:&argument objCType:argumentType];
	}
	
	return boxedArgument;
}

- (void)setMatchers:(NSArray *)matchers {
	NSMutableArray *nonObjectMatchers = [matchers mutableCopy];
	
	[self.invocation.methodSignature numberOfArguments];
	
	NSInteger numberOfNonObjectArguments = 0;
	NSMutableArray *objectMatchers = [NSMutableArray array];
	for (NSInteger i = 2; i < self.invocation.methodSignature.numberOfArguments; i++) {
		const char *argumentType = [self.invocation.methodSignature getArgumentTypeAtIndex:i];
		if (SBLIsObjectType(argumentType)) {
			__unsafe_unretained id argument = nil;
			[self.invocation getArgument:&argument atIndex:i];
			if ([argument isKindOfClass:[SBLMatcher class]]) {
				[objectMatchers addObject:argument];
				[nonObjectMatchers removeObject:argument];
			} else {
				[objectMatchers addObject:[SBLMatcher objectIsEqualMatcher:argument]];
			}
		} else {
			numberOfNonObjectArguments++;
		}
	}
	
	BOOL useMatchersForNonObjects = [nonObjectMatchers count];
	
	if (useMatchersForNonObjects && [nonObjectMatchers count] != numberOfNonObjectArguments) {
		[NSException raise:SBLBadUsage format:SBLBadMatchersProvided];
	}
	
	NSMutableArray *allMatchers = [NSMutableArray array];
	for (NSInteger i = 2; i < self.invocation.methodSignature.numberOfArguments; i++) {
		const char *argumentType = [self.invocation.methodSignature getArgumentTypeAtIndex:i];
		if (SBLIsObjectType(argumentType)) {
			[allMatchers addObject:objectMatchers[0]];
			[objectMatchers removeObjectAtIndex:0];
		} else if (useMatchersForNonObjects) {
			[allMatchers addObject:nonObjectMatchers[0]];
			[nonObjectMatchers removeObjectAtIndex:0];
		} else {
			NSValue *boxedValue = [self boxedValueForArgumentIndex:i inInvocation:self.invocation];
			[allMatchers addObject:[SBLMatcher valueIsEqualMatcher:boxedValue]];
		}
	}
	_matchers = allMatchers;
}

- (BOOL)matchesInvocation:(NSInvocation *)invocation {
	NSInvocation *recordedInvocation = self.invocation;
	BOOL matchingInvocation = recordedInvocation.selector == invocation.selector;
	if (matchingInvocation) {
		for (int i = 2; i < recordedInvocation.methodSignature.numberOfArguments; i++) {
			const char *argumentType = [self.invocation.methodSignature getArgumentTypeAtIndex:i];
            BOOL isObject = SBLIsObjectType(argumentType);
			__unsafe_unretained id argument = nil; // Need unsafe unretained here - http://stackoverflow.com/questions/11874056/nsinvocation-getreturnvalue-called-inside-forwardinvocation-makes-the-returned
			if (isObject) {
				[invocation getArgument:&argument atIndex:i];
			} else {
				argument = [self boxedValueForArgumentIndex:i inInvocation:invocation];
			}
			SBLMatcher *matcher = self.matchers[i-2];
			matchingInvocation &= [matcher matchesArgument:argument shouldUnboxArgument:!isObject];
		}
	}
    return matchingInvocation;
}

- (const char *)returnType {
	return self.invocation.methodSignature.methodReturnType;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"SBLInvocationRecord[%@]", NSStringFromSelector(self.invocation.selector)];
}

@end
