@interface STBStubbleCore : NSObject

+ (void)prepareForWhen;
+ (id)performWhen;

- (id)thenReturn:(id)returnValue;

@end