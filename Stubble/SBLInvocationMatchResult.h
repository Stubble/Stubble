#import <Foundation/Foundation.h>


@interface SBLInvocationMatchResult : NSObject

@property (nonatomic, readonly) BOOL invocationMatches;
@property (nonatomic, readonly) NSArray *argumentMatcherResults;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithInvocationMatches:(BOOL)invocationMatches argumentMatcherResults:(NSArray *)argumentMatcherResults;

@end