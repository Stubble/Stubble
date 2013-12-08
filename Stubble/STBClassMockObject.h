#import "STBMockObject.h"

@interface STBClassMockObject : NSProxy <STBMockObject>

- (id)initWithClass:(Class)class;

@end