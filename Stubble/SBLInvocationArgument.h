#import <Foundation/Foundation.h>

@interface SBLInvocationArgument : NSObject

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithArgument:(id)argument shouldUnbox:(BOOL)shouldUnbox isBlock:(BOOL)isBlock;

@property (nonatomic, readonly) id argument;
@property (nonatomic, readonly) BOOL shouldUnbox;

@end
