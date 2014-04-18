@interface SBLTimesMatcher : NSObject

@property (nonatomic, readonly) NSInteger atLeast;
@property (nonatomic, readonly) NSInteger atMost;
@property (nonatomic, readonly) NSString *formattedTimes;

+ (instancetype)never;
+ (instancetype)between:(NSInteger)minTimes andAtMost:(NSInteger)maxTimes;
+ (instancetype)exactly:(NSInteger)times;
+ (instancetype)atLeast:(NSInteger)minTimes;

@end