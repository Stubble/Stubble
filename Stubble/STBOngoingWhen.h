@interface STBOngoingWhen : NSObject

@property (nonatomic, readonly) void *returnValue;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithInvocation:(NSInvocation *)invocation;

- (STBOngoingWhen *)thenReturn:(id)returnValue;

@end