
@interface SBLTestingClass : NSObject

- (NSString *)methodReturningString;

- (NSArray *)methodWithArray:(NSArray *)array;

- (id)methodWithVariableNumberOfArguments:(id)argument1, ...;

- (int)methodReturningInt;

- (NSValue *)methodReturningNSValue;

- (NSString *)methodWithManyArguments:(NSString *)argument1 primitive:(NSInteger)argument2 number:(NSNumber *)number;

@end
