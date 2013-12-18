#import <Foundation/Foundation.h>


@interface SBLTimesMatcher : NSObject

@property (nonatomic, readonly) int atLeast;
@property (nonatomic, readonly) int atMost;

+ (instancetype)never;
+ (instancetype)exactly:(int)times;
+ (instancetype)atLeast:(int)minTimes;
+ (instancetype)between:(int)minTimes andAtMost:(int)maxTimes;

@end