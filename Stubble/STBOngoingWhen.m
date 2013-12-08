#import "STBOngoingWhen.h"
#import "STBStubbleCore.h"

@interface STBOngoingWhen ()

@property (nonatomic, readonly) NSInvocation *invocation;
@property (nonatomic, readwrite) void *returnValue;

@end

@implementation STBOngoingWhen

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
	if (self = [super init]) {
		_invocation = invocation;
	}
	return self;
}

- (STBOngoingWhen *)thenReturn:(id)returnValue {
	self.returnValue = (__bridge void *)returnValue;
	
    // TODO verify that it makes sense for the current invocation
    // TODO eventually self can be used for some type of chaining
    return self;
}

@end