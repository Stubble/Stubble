#import <Foundation/Foundation.h>

@interface SBLArgumentMatcherResult : NSObject

@property (nonatomic, readonly) BOOL matches;
@property (nonatomic, readonly) NSString *expectedArgumentStringValue;
@property (nonatomic, readonly) NSString *actualArgumentStringValue;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithMatches:(BOOL)matches expectedArgumentForLogging:(NSObject *)expectedArgument actualArgumentForLogging:(NSObject *)actualArgument;

@end