#import <Foundation/Foundation.h>


@interface SBLTimesMatcher : NSObject

@property (nonatomic, readonly) int atLeast;
@property (nonatomic, readonly) int atMost;

+ (instancetype)atLeast:(int)times;

// TODO: Other obvious instances: exactly, never, between

@end