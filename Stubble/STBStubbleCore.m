#import "STBStubbleCore.h"
#import "STBOngoingWhen.h"

@interface STBStubbleCore ()

@property(nonatomic, readwrite) BOOL whenInProgress;
@property(nonatomic) id<STBMockObject> mockForCurrentWhen;

@end

@implementation STBStubbleCore

+ (id)core {
    static dispatch_once_t once;
    static STBStubbleCore *sharedInstance;
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

- (void)whenMethodInvokedForMock:(id<STBMockObject>)mock {
    self.mockForCurrentWhen = mock;
}

- (id)performWhen {
    if (!self.mockForCurrentWhen) {
        NSLog(@"Error: called WHEN without calling a mock method.");
    }
    NSLog(@"performWhen");

    // TODO clear the flag?  We could also do that in the mock itself.
    return [[STBOngoingWhen alloc] init];
}

- (void)returnValueSetForCurrentWhen:(id)value {
    [self.mockForCurrentWhen setReturnValueForCurrentWhen:value];
    // TODO add the return value for the last invoked mock
}

@end