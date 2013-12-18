#import <Foundation/Foundation.h>


@interface SBLTimesMatcher : NSObject

@property (nonatomic, readonly) int atLeast;
@property (nonatomic, readonly) int atMost;

+ (instancetype)never;
+ (instancetype)exactly:(int)times;

@end