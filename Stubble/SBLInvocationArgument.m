#import "SBLInvocationArgument.h"

@interface SBLInvocationArgument ()

@property (nonatomic, readonly) BOOL isBlock;

@end

@implementation SBLInvocationArgument

- (instancetype)initWithArgument:(id)argument shouldUnbox:(BOOL)shouldUnbox isBlock:(BOOL)isBlock {
    if (self = [super init]) {
        if (isBlock) {
            _argument = [argument copy];
        } else {
            _argument = argument;
        }
        _shouldUnbox = shouldUnbox;
        _isBlock = isBlock;
    }
    return self;
}

// TODO - is copy required for blocks here?
//- (id)argument {
//    id argument = _argument;
//    if (self.isBlock) {
//        argument = [_argument copy];
//    }
//    return argument;
//}

@end
