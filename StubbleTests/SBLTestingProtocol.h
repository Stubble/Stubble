#import <Foundation/Foundation.h>

@protocol SBLTestingProtocol

- (NSString *)protocolMethodWithObject:(NSNumber *)number;
- (NSString *)protocolMethodWithInteger:(NSInteger)integer;

@optional

- (NSString *)optionalProtocolMethodWithObject:(NSNumber *)number;
- (NSString *)optionalProtocolMethodWithInteger:(NSInteger)integer;

@end
