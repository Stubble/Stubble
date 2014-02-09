#import "SBLMatcher.h"

@interface SBLMatcher ()<NSCopying>

@property (nonatomic, copy) SBLMatcherBlock matcherBlock;
@property (nonatomic, readonly) NSUUID *uuid;
@property (nonatomic, copy) SBLMatcherPlaceholderBlock placeholderBlock;
@property (nonatomic) SBLMatcher *memoryHack;

@end

@implementation SBLMatcher

+ (instancetype)any {
	return [SBLMatcher matcherWithBlock:^BOOL(id argument, BOOL shouldUnboxArgument) {
		return YES;
	}];
}

+ (instancetype)captor:(void *)captor {
	NSValue *pointerValue = [NSValue valueWithPointer:captor];
	return [SBLMatcher matcherWithBlock:^BOOL(id argument, BOOL shouldUnboxArgument) {
        void *captorPointer = [pointerValue pointerValue];

        if (shouldUnboxArgument) {
            [(NSValue *)argument getValue:captorPointer];
        } else {
            if (SBLIsBlock(argument)) {
                argument = [argument copy];
            }
            __block id __strong *captorId = (id __strong *)captorPointer;
            *captorId = argument;
        }
		return YES;
	}];
}

+ (instancetype)objectIsEqualMatcher:(id)object {
	return [SBLMatcher matcherWithBlock:^BOOL(id argument, BOOL shouldUnboxArgument) {
		return [object isEqual:argument] || (!object && !argument);
	}];
}

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcherBlock {
	SBLMatcher *matcher = [[SBLMatcher alloc] init];
	matcher.matcherBlock = matcherBlock;
	return matcher;
}

+ (instancetype)valueIsEqualMatcher:(NSValue *)value {
	return [SBLMatcher matcherWithBlock:^BOOL(NSValue *argument, BOOL shouldUnboxArgument) {
		return [value isEqual:argument];
	}];
}

- (id)init {
    return [self initWithUUID:[NSUUID UUID]];
}

- (instancetype)initWithUUID:(NSUUID *)uuid {
    if (self = [super init]) {
        _uuid = uuid;
    }
    return self;
}

- (BOOL)matchesArgument:(id)argument shouldUnboxArgument:(BOOL)shouldUnboxArgument {
	return self.matcherBlock(argument, shouldUnboxArgument);
}

- (void *)placeholder {
	return (__bridge void *)self;
}

- (NSValue *)placeholderWithType:(char[])type {
	NSValue *placeholderValue = nil;
	if (SBLIsBlockType(type)) {
		NSLog(@"placeholderWithType: BLOCK %@", self);
		__weak typeof(self) weakSelf = self;
		self.memoryHack = self;
		if (!self.placeholderBlock) {
			self.placeholderBlock = ^{return weakSelf;};
		}
		placeholderValue = [NSValue value:&_placeholderBlock withObjCType:type];
	} else if (SBLIsObjectType(type)) {
		NSLog(@"placeholderWithType: OBJECT %@", self);
		self.memoryHack = self;
		SBLMatcher *placeholder = [self placeholder];
		placeholderValue = [NSValue value:&placeholder withObjCType:type];
	} else {
		NSLog(@"placeholderWithType: PRIMITIVE %@", self);
		void *placeholder = NULL;
		placeholderValue = [NSValue value:&placeholder withObjCType:type];
	}
	return placeholderValue;
}

- (void)getValue:(id *)value {
	*value = [self copy];
}

// need to implement this to support matching blocks
- (id)copyWithZone:(NSZone *)zone {
    SBLMatcher *copiedMatcher = [[[self class] allocWithZone:zone] initWithUUID:self.uuid];
    copiedMatcher.matcherBlock = self.matcherBlock;
    return copiedMatcher;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[SBLMatcher class]] && [self.uuid isEqual:[object uuid]];
}

- (BOOL)isBlockPlaceholderForMatcher:(SBLMatcherPlaceholderBlock)block {
	return self.placeholderBlock != nil && block == self.placeholderBlock;
}

- (NSUInteger)hash {
    return [self.uuid hash];
}

@end
