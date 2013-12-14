struct SBLTestStructA {
	double variable1;
	NSInteger variable2;
};

struct SBLTestStructB {
	const char *variable1;
	struct SBLTestStructA variable2;
	SEL variable3;
	float variable4;
};

@interface SBLTestingClass : NSObject

- (NSString *)methodReturningString;

- (NSArray *)methodWithArray:(NSArray *)array;

- (id)methodWithVariableNumberOfArguments:(id)argument1, ...;

- (int)methodReturningInt;

- (NSValue *)methodReturningNSValue;

- (NSString *)methodWithManyArguments:(NSString *)argument1 primitive:(NSInteger)argument2 number:(NSNumber *)number;

- (void)methodWithBool:(BOOL)argument;

- (NSString *)methodWithInteger:(NSInteger)integer;
- (NSString *)methodWithObject:(NSNumber *)number;

- (NSString *)methodWithArgument1:(NSString *)argument1 argument2:(NSString *)argument2;

- (NSString *)methodWithArgument1:(NSString *)argument1
						argument2:(NSInteger)argument2
						argument3:(NSInteger)argument3
						argument4:(NSString *)argument4
						argument5:(BOOL)argument5;

@end
