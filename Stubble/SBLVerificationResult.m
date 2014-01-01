#import "SBLVerificationResult.h"

@implementation SBLVerificationResult

- (instancetype)initWithSuccess:(BOOL)success failureDescription:(NSString *)failureDescription {
	if (self = [super init]) {
		_successful = success;
		_failureDescription = failureDescription;
	}
	return self;
}

@end
