#import "SBLInvocationRecord.h"
#import "SBLErrors.h"

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

- (BOOL)isObjectType:(const char *)type {
	return (strchr("@#", type[0]) != NULL);
}

- (NSValue *)boxedValueForArgumentIndex:(NSInteger)index inInvocation:(NSInvocation *)invocation {
	const char *argumentType = [invocation.methodSignature getArgumentTypeAtIndex:index];
	BOOL isStruct = argumentType[0] == '{';
	void *argument;
	if (isStruct) {
		NSUInteger typeSize = 0;
		NSGetSizeAndAlignment(argumentType, &typeSize, NULL);
		argument = malloc(typeSize);
	}
	
	[invocation getArgument:&argument atIndex:index];
	NSValue *boxedArgument = [NSValue valueWithBytes:&argument objCType:argumentType];
	
	if (isStruct) {
		free(argument);
	}
	return boxedArgument;
}

- (void)setMatchers:(NSArray *)matchers {
	NSLog(@"setMatchers: %p %@", self, matchers);
	
	NSMutableArray *nonObjectMatchers = [matchers mutableCopy];
	
	[self.invocation.methodSignature numberOfArguments];
	
	NSInteger numberOfNonObjectArguments = 0;
	NSMutableArray *objectMatchers = [NSMutableArray array];
	for (NSInteger i = 2; i < self.invocation.methodSignature.numberOfArguments; i++) {
		const char *argumentType = [self.invocation.methodSignature getArgumentTypeAtIndex:i];
		if ([self isObjectType:argumentType]) {
			id argument = nil;
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
		if ([self isObjectType:argumentType]) {
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
	NSLog(@"matchesInvocation: %@", invocation);
	NSLog(@"matchers: %p %@", self, self.matchers);
	NSInvocation *recordedInvocation = self.invocation;
	BOOL matchingInvocation = recordedInvocation.selector == invocation.selector;
	if (matchingInvocation) {
		for (int i = 2; i < recordedInvocation.methodSignature.numberOfArguments; i++) {
			const char *argumentType = [self.invocation.methodSignature getArgumentTypeAtIndex:i];
			__unsafe_unretained id argument = nil; // Need unsafe unretained here - http://stackoverflow.com/questions/11874056/nsinvocation-getreturnvalue-called-inside-forwardinvocation-makes-the-returned
			if ([self isObjectType:argumentType]) {
				[invocation getArgument:&argument atIndex:i];
			} else {
				argument = [self boxedValueForArgumentIndex:i inInvocation:invocation];
			}
			SBLMatcher *matcher = self.matchers[i-2];
			matchingInvocation &= [matcher matchesArgument:argument];
		}
	}
    return matchingInvocation;
}

- (BOOL)typeIsObject:(const char *)type {
    return strcmp(type, "@") == 0;
}

- (const char *)returnType {
	return self.invocation.methodSignature.methodReturnType;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"SBLInvocationRecord[%@]", NSStringFromSelector(self.invocation.selector)];
}

@end
