#import "SBLValueLoggingHelper.h"

@implementation SBLValueLoggingHelper

- (NSString *)stringValueForValue:(NSValue *)value type:(const char *)type {
    if (strcmp(type, @encode(int)) == 0) {
        int unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%d", unwrappedValue];
    } else if (strcmp(type, @encode(short)) == 0) {
        short unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%hi", unwrappedValue];
    } else if (strcmp(type, @encode(double)) == 0) {
        double unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%g", unwrappedValue];
    } else if (strcmp(type, @encode(long)) == 0) {
        long unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%li", unwrappedValue];
    } else if (strcmp(type, @encode(float)) == 0) {
        float unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%g", unwrappedValue];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%lld", unwrappedValue];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%u", unwrappedValue];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%hu", unwrappedValue];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%lu", unwrappedValue];
    } else if (strcmp(type, @encode(bool)) == 0) {
        BOOL unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%@", unwrappedValue ? @"YES" : @"NO"];
    }  else if (strcmp(type, @encode(BOOL)) == 0 && [value isKindOfClass:[NSNumber class]]) {
        BOOL unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%@", unwrappedValue ? @"YES" : @"NO"];
    } else if (strcmp(type, @encode(char)) == 0) {
        char unwrappedCharValue;
        [value getValue:&unwrappedCharValue];
        return [NSString stringWithFormat:@"%c", unwrappedCharValue];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%hhu", unwrappedValue];
    }
    return nil;
}

@end