#import <Foundation/Foundation.h>


@interface SBLValueLoggingHelper : NSObject

- (NSString *)stringValueForValue:(NSValue *)value type:(const char *)type;

@end