@interface STBOngoingWhen : NSObject

@property (nonatomic, readonly) id returnValue;
@property (nonatomic, readonly) BOOL shouldUnboxReturnValue;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithInvocation:(NSInvocation *)invocation;

- (STBOngoingWhen *)thenReturn:(id)returnValue;

@end