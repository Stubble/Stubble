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

- (BOOL)shouldUnboxReturnValue {
	//	NSLog(@"NSObject * : %s", [self.returnValue objCType]);
	//	NSLog(@"methodReturnType : %s", [[self.invocation methodSignature] methodReturnType]);
	return [self.returnValue isKindOfClass:[NSValue class]] && strcmp([[self.invocation methodSignature] methodReturnType], [self.returnValue objCType]) == 0;
}

- (BOOL)matchesInvocation:(NSInvocation *)invocation {
	// TODO - check that parameters match
    return [SBLStubbleCore actualInvocation:invocation matchesMockInvocation:self.invocation];
}



@end