#import "SBLStubbleCore.h"

@interface SBLStubbleCore ()

@property(nonatomic, readwrite) BOOL whenInProgress;
@property(nonatomic) id<SBLMockObject> mockForCurrentWhen;

@end

@implementation SBLStubbleCore

+ (id)core {
    static dispatch_once_t once;
    static SBLStubbleCore *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)prepareForWhen {
    NSLog(@"prepareForWhen");

    self.mockForCurrentWhen = nil;
    self.whenInProgress = YES;

    // TODO: set a flag that mocks can read telling them that the next call is actually a stub setup
}

- (void)whenMethodInvokedForMock:(id<SBLMockObject>)mock {
    self.mockForCurrentWhen = mock;
}

- (SBLOngoingWhen *)performWhen {
    if (!self.mockForCurrentWhen) {
		// TODO throw exception here?
        NSLog(@"Error: called WHEN without calling a mock method.");
    }
    NSLog(@"performWhen");

	self.whenInProgress = NO;
    return self.mockForCurrentWhen.currentOngoingWhen;
}

@end