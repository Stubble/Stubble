#import <Foundation/Foundation.h>
#import "SBLVerificationResult.h"

@interface SBLVerificationHandler : NSObject

+ (void)handleVerificationResult:(SBLVerificationResult *)verificationResult inTestCase:(id)testCase inFile:(const char *)file onLine:(NSUInteger)line;

@end
