#import "SBLTestingBlockCreator.h"

@implementation SBLTestingBlockCreator

- (void)runInBlockWithNumber:(int)number {
    __weak typeof(self) weakSelf = self;
    [self.sender methodWithBlock:^(int integer, NSObject *object) {
        [weakSelf.receiver methodWithInteger:number];
    }];
}

@end
