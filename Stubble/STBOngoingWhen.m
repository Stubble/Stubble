#import "STBOngoingWhen.h"
#import "STBStubbleCore.h"

@interface STBOngoingWhen ()

@property (nonatomic, readonly) NSInvocation *invocation;
@property (nonatomic, readwrite) id returnValue;

@end

@implementation STBOngoingWhen

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
	if (self = [super init]) {
		_invocation = invocation;
	}
	return self;
}

- (STBOngoingWhen *)thenReturn:(id)returnValue {
	self.returnValue = returnValue;
	
    // TODO verify that it makes sense for the current invocation
    // TODO eventually self can be used for some type of chaining
    return self;
}

- (BOOL)shouldUnboxReturnValue {
//	NSLog(@"NSObject * : %s", [self.returnValue objCType]);
//	NSLog(@"methodReturnType : %s", [[self.invocation methodSignature] methodReturnType]);
	return [self.returnValue isKindOfClass:[NSValue class]] && strcmp([[self.invocation methodSignature] methodReturnType], [self.returnValue objCType]) == 0 ;
}

@end