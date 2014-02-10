#import "SBLMatcher.h"

typedef void(^SBLMatcherPostInvocationMatchBlock)(SBLInvocationArgument *argument);

@interface SBLMatcher ()<NSCopying>

@property (nonatomic, copy) SBLMatcherBlock matcherBlock;
@property (nonatomic, copy) SBLMatcherPostInvocationMatchBlock postInvocationMatchBlock;
@property (nonatomic, readonly) NSUUID *uuid;
@property (nonatomic, copy) SBLMatcherPlaceholderBlock placeholderBlock;
@property (nonatomic) SBLMatcher *memoryHack;

@end

@implementation SBLMatcher

+ (instancetype)any {
	return [SBLMatcher matcherWithBlock:^BOOL(SBLInvocationArgument *argument) {
		return YES;
	}];
}

+ (instancetype)captor:(void *)captor {
	NSValue *pointerValue = [NSValue valueWithPointer:captor];
	SBLMatcher *matcher = [SBLMatcher any];
    matcher.postInvocationMatchBlock = ^(SBLInvocationArgument *argument) {
        void *captorPointer = [pointerValue pointerValue];
        id capturedArgument = argument.argument;
        
        if (argument.shouldUnbox) {
            [(NSValue *)capturedArgument getValue:captorPointer];
        } else {
            if (SBLIsBlock(capturedArgument)) {
                capturedArgument = [capturedArgument copy];
            }
            __block id __strong *captorId = (id __strong *)captorPointer;
            *captorId = capturedArgument;
        }
    };
    return matcher;
}

+ (instancetype)objectIsEqualMatcher:(id)object {
	return [SBLMatcher matcherWithBlock:^BOOL(SBLInvocationArgument *argument) {
		return [object isEqual:argument.argument] || (!object && !argument.argument);
	}];
}

+ (instancetype)matcherWithBlock:(SBLMatcherBlock)matcherBlock {
	SBLMatcher *matcher = [[SBLMatcher alloc] init];
	matcher.matcherBlock = matcherBlock;
	return matcher;
}

+ (instancetype)valueIsEqualMatcher:(NSValue *)value {
	return [SBLMatcher matcherWithBlock:^BOOL(SBLInvocationArgument *argument) {
		return [value isEqual:argument.argument];
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

- (void)postInvocationMatchActionWithArgument:(SBLInvocationArgument *)argument {
    if (self.postInvocationMatchBlock) {
        self.postInvocationMatchBlock(argument);
    }
}

- (BOOL)matchesArgument:(SBLInvocationArgument *)argument {
	return self.matcherBlock(argument);
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
