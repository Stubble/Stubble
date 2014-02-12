#import "SBLInvocationArgument.h"
#import "SBLHelpers.h"

@implementation SBLInvocationArgument

- (instancetype)initWithArgument:(id)argument type:(const char *)type {
    if (self = [super init]) {
		BOOL isBlock = SBLIsBlockType(type);
		BOOL isObject = SBLIsObjectType(type);
        if (SBLIsBlockType(type)) {
            _argument = [argument copy];
        } else {
            _argument = argument;
        }
        _shouldUnbox = !isObject;
		_isObject = isObject;
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
