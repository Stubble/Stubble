#import <Foundation/Foundation.h>

@protocol SBLMockObjectBehavior <NSObject>

- (NSMethodSignature *)mockObjectMethodSignatureForSelector:(SEL)aSelector;
- (BOOL)mockObjectRespondsToSelector:(SEL)aSelector;
- (BOOL)mockObjectIsKindOfClass:(Class)aClass;
- (BOOL)mockObjectConformsToProtocol:(Protocol *)aProtocol;

@end
