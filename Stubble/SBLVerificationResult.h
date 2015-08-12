#import <Foundation/Foundation.h>

@interface SBLVerificationResult : NSObject

@property (nonatomic, readonly) BOOL successful;
@property (nonatomic, readonly) NSString *failureDescription;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithSuccess:(BOOL)success failureDescription:(NSString *)failureDescription;

@end
