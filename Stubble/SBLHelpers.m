#import "SBLHelpers.h"

BOOL SBLIsObjectType(const char *type) {
	return (strchr("@#", type[0]) != NULL);
}

BOOL SBLIsBlockType(const char *type) {
	return (strcmp("@?", type) == 0);
}

BOOL SBLIsBlock(id item) {
    BOOL isBlock = NO;
	
    // find the block class at runtime in case it changes in a different OS version
    static Class blockClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id block = ^{};
        blockClass = [block class];
        while ([blockClass superclass] != [NSObject class]) {
            blockClass = [blockClass superclass];
        }
    });
	
    isBlock = [item isKindOfClass:blockClass];
	
    return isBlock;
}