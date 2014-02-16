#import <Foundation/Foundation.h>


@interface SBLMatcherResult : NSObject

@property (nonatomic, readonly) BOOL matches;
@property (nonatomic, readonly) NSString *expectedParameters;
@property (nonatomic, readonly) NSString *actualParameters;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithMatches:(BOOL)matches;
- (instancetype)initWithMatches:(BOOL)matches expectedParameters:(NSString *)expectedParameters actualParameters:(NSString *)actualParameters;

@end