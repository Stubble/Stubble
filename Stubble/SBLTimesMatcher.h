#import <Foundation/Foundation.h>


@interface SBLTimesMatcher : NSObject

@property (nonatomic, readonly) NSInteger atLeast;
@property (nonatomic, readonly) NSInteger atMost;

+ (instancetype)never;
+ (instancetype)exactly:(NSInteger)times;
+ (instancetype)atLeast:(NSInteger)minTimes;

@end