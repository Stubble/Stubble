#import "SBLClassMockObjectBehavior.h"
#import "SBLTransactionManager.h"
#import <objc/runtime.h>

@interface SBLClassMockObjectBehavior ()

@property (nonatomic, readonly) Class mockedClass;
@property (nonatomic, readonly) NSMutableDictionary *knownDynamicSelectorToMethodSignatureDictionary;

@end

@implementation SBLClassMockObjectBehavior

- (instancetype)initWithClass:(Class)aClass dynamic:(BOOL)dynamic {
	if (self = [super init]) {
		_mockedClass = aClass;
		Class nsManagedObject = NSClassFromString(@"NSManagedObject");
		BOOL coreData = nsManagedObject && (aClass == nsManagedObject || [aClass isSubclassOfClass:nsManagedObject]);
		if (dynamic || coreData) {
			NSMutableDictionary *knownDynamicSelectorToMethodSignatureDictionary = [NSMutableDictionary dictionary];
			_knownDynamicSelectorToMethodSignatureDictionary = knownDynamicSelectorToMethodSignatureDictionary;
		}
	}
	return self;
}

- (NSMethodSignature *)mockObjectMethodSignatureForSelector:(SEL)aSelector {
	NSMethodSignature *methodSignature = [self.mockedClass instanceMethodSignatureForSelector:aSelector];
	if (!methodSignature && self.knownDynamicSelectorToMethodSignatureDictionary) {
		methodSignature = self.knownDynamicSelectorToMethodSignatureDictionary[NSStringFromSelector(aSelector)];
		if (!methodSignature) {
			methodSignature = [self methodSignatureFromClassPropertiesMatchingSelector:aSelector];
		}
		if (!methodSignature) {
			NSString *knownReturnType = SBLTransactionManager.currentTransactionManager.currentWhenReturnType;
			NSString *returnType = knownReturnType ?: @"@";
			NSUInteger numberOfArguments = [NSStringFromSelector(aSelector) componentsSeparatedByString:@":"].count - 1;
			NSString *allTypes = [returnType stringByAppendingString:@"@:"];
			for (int i = 0; i < numberOfArguments; i++) {
				allTypes = [allTypes stringByAppendingString:@"@"];
			}
			methodSignature = [NSMethodSignature signatureWithObjCTypes:allTypes.UTF8String];
			if (knownReturnType) {
				self.knownDynamicSelectorToMethodSignatureDictionary[NSStringFromSelector(aSelector)] = methodSignature;
			}
		}

	}
    return methodSignature;
}

- (NSMethodSignature *)methodSignatureFromClassPropertiesMatchingSelector:(SEL)selector {
	NSMethodSignature *methodSignature = nil;
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(self.mockedClass, &propertyCount);
	for(int index = 0; index < propertyCount; index++) {
		objc_property_t property = properties[index];
		NSArray *attributes = [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","];
		BOOL isDynamic = [attributes containsObject:@"D"];
		if (isDynamic) {
			NSString *typeString = [[self valueForCode:@"T" fromAttributes:attributes] substringToIndex:1];
			NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
			NSString *getterName = [self valueForCode:@"G" fromAttributes:attributes] ?: propertyName;
			if (NSSelectorFromString(getterName) == selector) {
				methodSignature = [NSMethodSignature signatureWithObjCTypes:[typeString stringByAppendingString:@"@:"].UTF8String];
				break;
			}

			BOOL readonly = [attributes containsObject:@"R"];
			if (!readonly) {
				NSString *setterName = [self valueForCode:@"S" fromAttributes:attributes] ?: [NSString stringWithFormat:@"set%@%@:", [propertyName substringToIndex:1].uppercaseString, [propertyName substringFromIndex:1]];
				if (NSSelectorFromString(setterName) == selector) {
					methodSignature = [NSMethodSignature signatureWithObjCTypes:[@"v@:" stringByAppendingString:typeString].UTF8String];
					break;
				}
			}
		}
	}
	free(properties);
	return methodSignature;
}

- (BOOL)mockObjectRespondsToSelector:(SEL)aSelector {
    return [self.mockedClass instancesRespondToSelector:aSelector];
}

- (BOOL)mockObjectIsKindOfClass:(Class)aClass {
    return [self.mockedClass isSubclassOfClass:aClass];
}

- (BOOL)mockObjectConformsToProtocol:(Protocol *)aProtocol {
    return [self.mockedClass conformsToProtocol:aProtocol];
}

- (NSString *)valueForCode:(NSString *)codeLetter fromAttributes:(NSArray *)attributes {
	NSString *value = nil;
	for (NSString *attribute in attributes) {
		if ([codeLetter isEqualToString:[attribute substringToIndex:1]]) {
			value = [attribute substringFromIndex:1];
		}
	}
	return value;
}

@end
