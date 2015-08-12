#import <Foundation/Foundation.h>
#import "SBLMockObjectBehavior.h"

@interface SBLClassMockObjectBehavior : NSObject<SBLMockObjectBehavior>

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithClass:(Class)aClass dynamic:(BOOL)dynamic;

@end
