#import "SBLInvocationRecord.h"
#import "SBLErrors.h"
#import "SBLHelpers.h"
#import "SBLInvocationArgument.h"

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

- (void)setMatchers:(NSArray *)matchers {
	NSMutableArray *remainingMatchers = [matchers mutableCopy];
	
	[self.invocation.methodSignature numberOfArguments];
	
	NSInteger numberOfNonObjectArguments = 0;
	NSMutableArray *objectMatchers = [NSMutableArray array];
	for (NSInteger i = 2; i < self.invocation.methodSignature.numberOfArguments; i++) {
		const char *argumentType = [self.invocation.methodSignature getArgumentTypeAtIndex:i];
		if (SBLIsObjectType(argumentType)) {
			__unsafe_unretained id argument = nil;
			[self.invocation getArgument:&argument atIndex:i];
			if (SBLIsBlock(argument)) {
				for (SBLMatcher *matcher in remainingMatchers) {
					if ([matcher isBlockPlaceholderForMatcher:argument]) {
						argument = matcher;
						break;
					}
				}
			}
			if ([argument isKindOfClass:[SBLMatcher class]]) {
				[objectMatchers addObject:argument];
				[remainingMatchers removeObject:argument];
			} else {
				[objectMatchers addObject:[SBLMatcher objectIsEqualMatcher:argument]];
			}
		} else {
			numberOfNonObjectArguments++;
		}
	}
	
	BOOL useMatchersForNonObjects = [remainingMatchers count];
	
	if (useMatchersForNonObjects && [remainingMatchers count] != numberOfNonObjectArguments) {
		[NSException raise:SBLBadUsage format:SBLBadMatchersProvided];
	}
	
	NSMutableArray *allMatchers = [NSMutableArray array];
	for (NSInteger i = 2; i < self.invocation.methodSignature.numberOfArguments; i++) {
		const char *argumentType = [self.invocation.methodSignature getArgumentTypeAtIndex:i];
		if (SBLIsObjectType(argumentType)) {
			[allMatchers addObject:objectMatchers[0]];
			[objectMatchers removeObjectAtIndex:0];
		} else if (useMatchersForNonObjects) {
			[allMatchers addObject:remainingMatchers[0]];
			[remainingMatchers removeObjectAtIndex:0];
		} else {
			NSValue *boxedValue = [self.class boxedValueForArgumentIndex:i inInvocation:self.invocation];
			[allMatchers addObject:[SBLMatcher valueIsEqualMatcher:boxedValue]];
		}
	}
	_matchers = allMatchers;
}

- (BOOL)matchesInvocation:(NSInvocation *)invocation {
	NSInvocation *recordedInvocation = self.invocation;
	BOOL matchingInvocation = recordedInvocation.selector == invocation.selector;
	if (matchingInvocation) {
        NSArray *arguments = [self.class argumentsFromInvocation:invocation];
        NSInteger index = 0;
        for (SBLInvocationArgument *argument in arguments) {
            SBLMatcher *matcher = self.matchers[index];
			matchingInvocation &= [matcher matchesArgument:argument];
            index++;
        }
        if (matchingInvocation) {
            index = 0;
            for (SBLInvocationArgument *argument in arguments) {
                SBLMatcher *matcher = self.matchers[index];
                [matcher postInvocationMatchActionWithArgument:argument];
                index++;
            }
        }
	}
    return matchingInvocation;
}

+ (NSArray *)argumentsFromInvocation:(NSInvocation *)invocation {
    NSMutableArray *arguments = [NSMutableArray array];
    for (int i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
        const char *argumentType = [invocation.methodSignature getArgumentTypeAtIndex:i];
        BOOL isObject = SBLIsObjectType(argumentType);
        id argument = nil;
        if (isObject) {
            void *pointer;
            [invocation getArgument:&pointer atIndex:i];
            argument = (__bridge id)pointer;
        } else {
            argument = [self boxedValueForArgumentIndex:i inInvocation:invocation];
        }
        [arguments addObject:[[SBLInvocationArgument alloc] initWithArgument:argument shouldUnbox:!isObject isBlock:SBLIsBlockType(argumentType)]];
    }
    return arguments;
}


+ (NSValue *)boxedValueForArgumentIndex:(NSInteger)index inInvocation:(NSInvocation *)invocation {
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

- (const char *)returnType {
	return self.invocation.methodSignature.methodReturnType;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"SBLInvocationRecord[%@]", NSStringFromSelector(self.invocation.selector)];
}

@end
