#import <Foundation/Foundation.h>

@interface SBLTestingDynamicObject : NSObject

@property (nonatomic, getter=getValue1, setter=putValue1:) NSObject *value1;
@property (nonatomic, readonly, getter=getValue2) NSObject *value2;
@property (nonatomic) NSObject *value3;

@property (nonatomic, getter=getInt1, setter=putInt1:) int integer1;
@property (nonatomic, readonly, getter=getInt2) int integer2;
@property (nonatomic) int integer3;

@end
