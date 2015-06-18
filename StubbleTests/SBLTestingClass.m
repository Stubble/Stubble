#import "SBLTestingClass.h"

@implementation SBLTestingClass

- (void)methodWithNoReturn {

}

- (NSString *)methodReturningString {
    return @"123";
}

- (NSString *)methodWithBlock:(SBLTestingBlock)block {
    return @"123";
}

- (NSArray *)methodWithArray:(NSArray *)array {
	return array;
}

- (NSArray *)methodWithArray:(NSArray *)array block:(SBLTestingBlock)block {
    return array;
}

- (id)methodWithVariableNumberOfArguments:(id)argument1, ... {
	return @"";
}

- (int)methodReturningInt {
    return 123;
}

- (char)methodReturningChar {
    return '0';
}

- (unsigned char)methodReturningUnsignedChar {
    return '0';
}

- (short)methodReturningShort {
    return 123;
}

- (unsigned short)methodReturningUnsignedShort {
    return 123u;
}

- (unsigned int)methodReturningUnsignedInt {
    return 123u;
}

- (long)methodReturningLong {
    return 123L;
}

- (unsigned long)methodReturningUnsignedLong {
    return 123ul;
}

- (long long)methodReturningLongLong {
    return 123;
}

- (unsigned long long)methodReturningUnsignedLongLong {
    return 123ul;
}

- (float)methodReturningFloat {
    return 123.0f;
}

- (double)methodReturningDouble {
    return 123.0;
}

- (BOOL)methodReturningBool {
    return NO;
}

- (NSValue *)methodReturningNSValue {
    return @123;
}

- (NSString *)methodWithManyArguments:(NSString *)argument1 primitive:(NSInteger)argument2 number:(NSNumber *)number {
	return @"123";
}

- (NSString *)methodWithBool:(BOOL)argument {
	return @"123";
}

- (NSString *)methodWithInteger:(NSInteger)integer {
	return @"123";
}

- (NSString *)methodWithTimeInterval:(NSTimeInterval)timeInterval {
	return @"123";
}

- (NSString *)methodWithObject:(NSNumber *)number {
	return @"123";
}

- (void)methodWithCArray:(const char **)cArray {

}

- (NSString *)methodWithArgument:(NSString *)string block:(SBLTestingBlock)block {
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

- (NSString *)methodWithSelector:(SEL)selector {
	return @"123";
}

- (NSString *)methodWithClass:(Class)clazz {
	return @"123";
}

- (NSString *)methodWithReference:(NSString **)stringReference {
	return @"123";
}

- (NSString *)methodWithPrimitiveReference:(NSInteger *)integerReference {
	return @"123";
}

- (NSString *)methodWithStruct:(SBLTestingStruct)structArgument {
	return @"123";
}

- (NSString *)methodWithCGRect:(CGRect)rect {
	return @"123";
}

- (NSString *)methodWithStructReference:(SBLTestingStructRef)structReference {
	return @"123";
}

- (void)methodWithManyPrimitiveArguments:(int)intArg
                                shortArg:(short)shortArg
                                 longArg:(long)longArg
                             longLongArg:(long long)longLongArg
                               doubleArg:(double)doubleArg
                                floatArg:(float)floatArg
                                 uIntArg:(unsigned int)uIntArg
                               uShortArg:(unsigned short)uShortArg
                                uLongArg:(unsigned long)uLongArg
                                 charArg:(char)charArg
                                uCharArg:(unsigned char)uCharArg
                                 boolArg:(bool)boolArg {

}
@end
