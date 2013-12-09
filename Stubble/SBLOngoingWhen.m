#import "SBLOngoingWhen.h"
#import "SBLStubbleCore.h"

@interface SBLOngoingWhen ()

@property (nonatomic, readonly) NSInvocation *invocation;
@property (nonatomic, readwrite) id returnValue;

@end

@implementation SBLOngoingWhen

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
	if (self = [super init]) {
		[invocation retainArguments];
		_invocation = invocation;
	}
	return self;
}

- (SBLOngoingWhen *)thenReturn:(id)returnValue {
	self.returnValue = returnValue;
	
    // TODO verify that it makes sense for the current invocation
    // TODO eventually self can be used for some type of chaining
    return self;
}

- (BOOL)typeIsObject:(const char *)type {
	return strcmp(type, "@") == 0;
}

- (BOOL)shouldUnboxReturnValue {
	//	NSLog(@"NSObject * : %s", [self.returnValue objCType]);
	//	NSLog(@"methodReturnType : %s", [[self.invocation methodSignature] methodReturnType]);
	return [self.returnValue isKindOfClass:[NSValue class]] && strcmp([[self.invocation methodSignature] methodReturnType], [self.returnValue objCType]) == 0;
}

- (BOOL)matchesInvocation:(NSInvocation *)invocation {
	// TODO - check that parameters match
	BOOL matchingInvocation = invocation.selector == self.invocation.selector;
	for (int i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
		// Need unsafe unretained here - http://stackoverflow.com/questions/11874056/nsinvocation-getreturnvalue-called-inside-forwardinvocation-makes-the-returned
		__unsafe_unretained id argumentMatcher = nil;
		__unsafe_unretained id argument = nil;
		[self.invocation getArgument:&argumentMatcher atIndex:i];
		[invocation getArgument:&argument atIndex:i];
		
		if ([self typeIsObject:[self.invocation.methodSignature getArgumentTypeAtIndex:i]]) {
			matchingInvocation &= [argumentMatcher isEqual:argument];
		} else {
			matchingInvocation &= argumentMatcher == argument;
		}
	}
	
	return matchingInvocation;
}

@end