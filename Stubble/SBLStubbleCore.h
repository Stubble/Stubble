#import "SBLClassMockObject.h"
#import "SBLOngoingWhen.h"

@interface SBLStubbleCore : NSObject

@property(nonatomic, readonly) BOOL whenInProgress;
@property(nonatomic, readonly) BOOL verifyInProgress;

+ (SBLStubbleCore *)core;

- (void)prepareForWhen;
- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock;
- (SBLOngoingWhen *)performWhen;

- (void)prepareForVerify;
- (void)verifyMethodInvokedForMock:(id<SBLMockObject>)mock;
- (void)performVerify; // throws exception if verify fails

+ (BOOL)actualInvocation:(NSInvocation *)actual matchesMockInvocation:(NSInvocation *)mock;

@end