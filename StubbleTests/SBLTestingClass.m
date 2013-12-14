#import "SBLTestingClass.h"

@implementation SBLTestingClass

- (NSString *)methodReturningString {
    return @"123";
}

- (NSArray *)methodWithArray:(NSArray *)array {
	return array;
}

- (id)methodWithVariableNumberOfArguments:(id)argument1, ... {
	return @"";
}

- (int)methodReturningInt {
    return 123;
}

- (NSValue *)methodReturningNSValue {
    return @123;
}

- (NSString *)methodWithManyArguments:(NSString *)argument1 primitive:(NSInteger)argument2 number:(NSNumber *)number {
	return @"123";
}

- (void)methodWithBool:(BOOL)argument {
	
}

- (NSString *)methodWithInteger:(NSInteger)integer {
	return @"123";
}

- (NSString *)methodWithObject:(NSNumber *)number {
	return @"123";
}

- (NSString *)methodWithArgument1:(NSString *)argument1 argument2:(NSString *)argument2 {
	return @"123";
}

- (NSString *)methodWithArgument1:(NSString *)argument1
						argument2:(NSInteger)argument2
						argument3:(NSInteger)argument3
						argument4:(NSString *)argument4
						argument5:(BOOL)argument5 {
	return @"123";
}

@end
