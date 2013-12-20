#import <Foundation/Foundation.h>
#import "SBLMockObjectBehavior.h"

@interface SBLClassMockObjectBehavior : NSObject<SBLMockObjectBehavior>

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithClass:(Class)aClass;

@end
