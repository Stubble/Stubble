@interface SBLOngoingWhen : NSObject

@property (nonatomic, readonly) id returnValue;
@property (nonatomic, readonly) BOOL shouldUnboxReturnValue;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithInvocation:(NSInvocation *)invocation;

- (SBLOngoingWhen *)thenReturn:(id)returnValue;
- (BOOL)matchesInvocation:(NSInvocation *)invocation;

@end