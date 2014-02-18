#import "SBLValueLoggingHelper.h"

@implementation SBLValueLoggingHelper

- (NSString *)stringValueForValue:(NSValue *)value type:(const char *)type {
    if (strcmp(type, @encode(int)) == 0) {
        int unwrappedValue;
        return [self convertValue:value intoContainer:unwrappedValue formatSpecifier:@"%d"];
    } else if (strcmp(type, @encode(short)) == 0) {
        short unwrappedValue;
        return [self convertValue:value intoContainer:unwrappedValue formatSpecifier:@"%hi"];
    } else if (strcmp(type, @encode(double)) == 0) {
        double unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%g", unwrappedValue];
    } else if (strcmp(type, @encode(long)) == 0) {
        long unwrappedValue;
        return [self convertValue:value intoContainer:unwrappedValue formatSpecifier:@"%li"];
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
        return [self convertValue:value intoContainer:unwrappedValue formatSpecifier:@"%u"];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short unwrappedValue;
        return [self convertValue:value intoContainer:unwrappedValue formatSpecifier:@"%hu"];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long unwrappedValue;
        return [self convertValue:value intoContainer:unwrappedValue formatSpecifier:@"%lu"];
    } else if (strcmp(type, @encode(char)) == 0) {
        BOOL unwrappedBoolValue;
        [value getValue:&unwrappedBoolValue];
        if (unwrappedBoolValue == YES) {
            return @"YES";
        } else if (unwrappedBoolValue == NO) {
            return @"NO";
        }
        char unwrappedCharValue;
        [value getValue:&unwrappedCharValue];
        return [NSString stringWithFormat:@"%c", unwrappedCharValue];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char unwrappedValue;
        return [self convertValue:value intoContainer:unwrappedValue formatSpecifier:@"%hhu"];
    } else if (strcmp(type, @encode(bool)) == 0) {
        BOOL unwrappedValue;
        [value getValue:&unwrappedValue];
        return [NSString stringWithFormat:@"%@", unwrappedValue ? @"YES" : @"NO"];
    }
    return nil;
}

- (NSString *)convertValue:value intoContainer:(void *)container formatSpecifier:(NSString *)formatSpecifier {
    [value getValue:&container];
    return [NSString stringWithFormat:formatSpecifier, container];
}

@end