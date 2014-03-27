#import <Foundation/Foundation.h>

@interface SBLInvocationArgument : NSObject

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithArgument:(id)argument type:(const char *)type;

@property (nonatomic, readonly) id argument;
@property (nonatomic, readonly) const char * type;
@property (nonatomic, readonly) BOOL shouldUnbox;
@property (nonatomic, readonly) BOOL isObject;
@property (nonatomic, readonly) BOOL isBlock;

@end
