#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface SBLCoreDataChild : NSManagedObject

@property (nonatomic, retain) NSString * string1;
@property (nonatomic, retain) NSManagedObject *parent;

@end
