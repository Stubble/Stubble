#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SBLCoreDataChild;

@interface SBLCoreDataParent : NSManagedObject

@property (nonatomic, retain) NSNumber * booleanObject;
@property (nonatomic) BOOL booleanValue;
@property (nonatomic, retain) NSNumber * doubleObject;
@property (nonatomic, retain) NSString * stringObject;
@property (nonatomic) int32_t intValue;
@property (nonatomic) int64_t longValue;
@property (nonatomic, retain) NSSet *children;
@end

@interface SBLCoreDataParent (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(SBLCoreDataChild *)value;
- (void)removeChildrenObject:(SBLCoreDataChild *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
