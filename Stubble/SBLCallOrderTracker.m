#import "SBLCallOrderTracker.h"
#include <libkern/OSAtomic.h>

@implementation SBLCallOrderTracker

+ (long)nextCallOrder {
    static int64_t callOrder = 0;
    OSAtomicIncrement64(&callOrder);
    return (long) callOrder;
}

@end