#import <Foundation/Foundation.h>
#import "SBLTestingClass.h"

@interface SBLTestingBlockCreator : NSObject

@property (nonatomic) SBLTestingClass *sender;
@property (nonatomic) SBLTestingClass *receiver;

- (void)runInBlockWithNumber:(int)number;

@end
