#import <XCTest/XCTest.h>
#import "SBLValueLoggingHelper.h"

@interface SBLValueLoggingHelperTest : XCTestCase {
    SBLValueLoggingHelper *testObject;
}

@end

@implementation SBLValueLoggingHelperTest

- (void)setUp {
    [super setUp];
    testObject = [[SBLValueLoggingHelper alloc] init];
}

- (void)testCorrectValueLogging {
    int intV = 123;
    short shortV = 123;
    long longV = 123;
    long long longLongV = 123;
    double doubleV = 12.3;
    float floatV = 12.3f;
    unsigned int uIntV = 123;
    unsigned short uShortV = 123;
    unsigned long uLongV = 123;
    char charV = 'a';
    unsigned char uCharV = 123;
    bool boolV = NO;
    BOOL bigBoolV = YES;
    const char *type = @encode(int);
    NSValue *value = [NSValue valueWithBytes:&intV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"123");

    type = @encode(short);
    value = [NSValue valueWithBytes:&shortV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"123");

    type = @encode(long);
    value = [NSValue valueWithBytes:&longV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"123");

    type = @encode(long long);
    value = [NSValue valueWithBytes:&longLongV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"123");

    type = @encode(double);
    value = [NSValue valueWithBytes:&doubleV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"12.3");

    type = @encode(float);
    value = [NSValue valueWithBytes:&floatV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"12.3");

    type = @encode(unsigned int);
    value = [NSValue valueWithBytes:&uIntV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"123");

    type = @encode(unsigned short);
    value = [NSValue valueWithBytes:&uShortV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"123");

    type = @encode(unsigned long);
    value = [NSValue valueWithBytes:&uLongV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"123");

    type = @encode(char);
    value = [NSValue valueWithBytes:&charV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"a");

    type = @encode(unsigned char);
    value = [NSValue valueWithBytes:&uCharV objCType:type];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"123");

    type = @encode(bool);
    value = [NSNumber numberWithBool:NO];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"NO");

    type = @encode(bool);
    value = [NSNumber numberWithBool:YES];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"YES");

    type = @encode(BOOL);
    value = [NSNumber numberWithBool:NO];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"NO");

    type = @encode(BOOL);
    value = [NSNumber numberWithBool:YES];
    XCTAssertEqualObjects([testObject stringValueForValue:value type:type], @"YES");
}

@end