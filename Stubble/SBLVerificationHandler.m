#import "SBLVerificationHandler.h"

@protocol SBLPretendMethodExistsOnNSObjectToAvoidLinkingXCTest

- (void)recordFailureWithDescription:(NSString *)description
                              inFile:(NSString *)filename
                              atLine:(NSUInteger)lineNumber
                            expected:(BOOL)expected;

@end

@implementation SBLVerificationHandler

+ (void)handleVerificationResult:(SBLVerificationResult *)verificationResult inTestCase:(id)testCase inFile:(const char *)file onLine:(NSUInteger)line {
	// TODO support OCUnit, GHUnit, etc.
	if (!verificationResult.successful) {
		[(id<SBLPretendMethodExistsOnNSObjectToAvoidLinkingXCTest>)testCase recordFailureWithDescription:verificationResult.failureDescription inFile:[NSString stringWithUTF8String:file] atLine:line expected:YES];
	}
}

@end
