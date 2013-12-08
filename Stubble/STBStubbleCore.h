@interface STBStubbleCore : NSObject

+ (STBStubbleCore *)core;

- (void)prepareForWhen;
- (id)performWhen;

- (id)thenReturn:(id)returnValue;

@end