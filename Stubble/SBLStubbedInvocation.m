#import "SBLStubbedInvocation.h"
#import "SBLTransactionManager.h"

@interface SBLStubbedInvocation ()

@property (nonatomic, readwrite) NSArray *actionBlocks;

@end

@implementation SBLStubbedInvocation

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
	if (self = [super initWithInvocation:invocation]) {
		self.actionBlocks = @[];
	}
	return self;
}

- (SBLStubbedInvocation *)thenReturn:(id)returnValue {
    char const *returnType = self.returnType;
    BOOL shouldUnboxReturnValue = [returnValue isKindOfClass:NSValue.class] && strcmp(returnType, "@") != 0;

    [self thenDoWithInvocation:^(NSInvocation *invocation) {
		NSUInteger methodReturnLength = [[invocation methodSignature] methodReturnLength];
		if (shouldUnboxReturnValue) {
            NSValue *value = returnValue;
            if ([returnValue isKindOfClass:NSNumber.class]) {
                NSNumber *numberValue = returnValue;
                if (strcmp(returnType, "d") == 0) {
                    value = @(numberValue.doubleValue);
                } else if (strcmp(returnType, "f") == 0) {
                    value = @(numberValue.floatValue);
				} else if (strcmp(returnType, "q") == 0) {
                    value = @(numberValue.longLongValue);
				} else if (strcmp(returnType, "Q") == 0) {
                    value = @(numberValue.unsignedLongLongValue);
				}
				// TODO all the other primitive types as well
            }

			void *buffer = malloc(methodReturnLength);
			[value getValue:buffer];
			[invocation setReturnValue:buffer];
			free(buffer);
		} else {
            if (!methodReturnLength){
                // Throw Exception?
            } else {
                id invocationReturnValue = returnValue;
                [invocation setReturnValue:&invocationReturnValue];
            }
		}
	}];
	
    // TODO verify that it makes sense for the current invocation
    // TODO eventually self can be used for some type of chaining (Should anything be allowed after -thenReturn:?)
    return self;
}

- (SBLStubbedInvocation *)thenDo:(SBLActionBlock)actionBlock {
	SBLActionBlock block = [actionBlock copy];
	[self thenDoWithInvocation:^(NSInvocation *invocation) {
		block();
	}];
	return self;
}

- (SBLStubbedInvocation *)thenDoWithInvocation:(SBLInvocationActionBlock)actionBlock {
	self.actionBlocks = [self.actionBlocks arrayByAddingObject:[actionBlock copy]];
	return self;
}

@end