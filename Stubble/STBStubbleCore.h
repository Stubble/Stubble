#import "STBClassMockObject.h"

@interface STBStubbleCore : NSObject

@property(nonatomic, readonly) BOOL whenInProgress;

+ (STBStubbleCore *)core;

- (void)prepareForWhen;
- (void)whenMethodInvokedForMock:(id<STBMockObject>)mock;
- (id)performWhen;

- (void)returnValueSetForCurrentWhen:(id)value;

@end