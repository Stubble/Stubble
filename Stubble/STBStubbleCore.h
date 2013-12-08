#import "STBClassMockObject.h"
#import "STBOngoingWhen.h"

@interface STBStubbleCore : NSObject

@property(nonatomic, readonly) BOOL whenInProgress;

+ (STBStubbleCore *)core;

- (void)prepareForWhen;
- (void)whenMethodInvokedForMock:(id<STBMockObject>)mock;
- (STBOngoingWhen *)performWhen;

- (void)returnValueSetForCurrentWhen:(id)value;

@end