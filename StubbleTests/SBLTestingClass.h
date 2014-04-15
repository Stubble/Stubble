#import <CoreGraphics/CoreGraphics.h>

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

typedef struct SBLTestingStruct *SBLTestingStructRef;
typedef struct SBLTestingStruct {
    NSInteger integer;
    BOOL boolean;
    char *characters;
} SBLTestingStruct;

typedef void(^SBLTestingBlock)(int integer, NSObject *object);

@interface SBLTestingClass : NSObject

#pragma mark - Zero Parameter Methods

- (NSString *)methodReturningString;

- (NSValue *)methodReturningNSValue;

- (int)methodReturningInt;

- (char)methodReturningChar;

- (unsigned char)methodReturningUnsignedChar;

- (short)methodReturningShort;

- (unsigned short)methodReturningUnsignedShort;

- (unsigned int)methodReturningUnsignedInt;

- (long)methodReturningLong;

- (unsigned long)methodReturningUnsignedLong;

- (long long)methodReturningLongLong;

- (unsigned long long)methodReturningUnsignedLongLong;

- (float)methodReturningFloat;

- (double)methodReturningDouble;

- (BOOL)methodReturningBool;

#pragma mark - Single Parameter Methods

- (void)methodWithNoReturn;

- (NSString *)methodWithBool:(BOOL)argument;

- (NSString *)methodWithInteger:(NSInteger)integer;

- (NSString *)methodWithTimeInterval:(NSTimeInterval)timeInterval;

- (NSString *)methodWithSelector:(SEL)selector;

- (NSString *)methodWithClass:(Class)clazz;

- (NSString *)methodWithCGRect:(CGRect)rect;

- (NSString *)methodWithStruct:(SBLTestingStruct)structArgument;

- (NSString *)methodWithStructReference:(SBLTestingStructRef)structReference;

- (NSString *)methodWithPrimitiveReference:(NSInteger *)integerReference;

- (NSString *)methodWithReference:(NSString **)stringReference;

- (NSArray *)methodWithBlock:(SBLTestingBlock)block;

- (NSArray *)methodWithArray:(NSArray *)array;

- (NSString *)methodWithObject:(NSNumber *)number;

- (void)methodWithCArray:(const char **)cArray;

#pragma mark - Multiple Arguments

- (NSString *)methodWithArgument:(NSString *)string block:(SBLTestingBlock)block;

- (id)methodWithVariableNumberOfArguments:(id)argument1, ...;

- (NSString *)methodWithArgument1:(NSString *)argument1 argument2:(NSString *)argument2;

- (NSString *)methodWithManyArguments:(NSString *)argument1 primitive:(NSInteger)argument2 number:(NSNumber *)number;

- (NSString *)methodWithArgument1:(NSString *)argument1
                        argument2:(NSInteger)argument2
                        argument3:(NSInteger)argument3
                        argument4:(NSString *)argument4
                        argument5:(BOOL)argument5;

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
                                 boolArg:(bool)boolArg;


@end
