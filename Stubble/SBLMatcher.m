#import "SBLMatcher.h"
#import "SBLHelpers.h"

@interface SBLMatcher ()<NSCopying>

@property (nonatomic, copy) SBLMatcherBlock matcherBlock;
@property (nonatomic, readonly) NSUUID *uuid;

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
            if ([SBLMatcher isBlock:argument]) {
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

+ (BOOL)isBlock:(id)item {
    BOOL isBlock = NO;

    // find the block class at runtime in case it changes in a different OS version
    static Class blockClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id block = ^{};
        blockClass = [block class];
        while ([blockClass superclass] != [NSObject class]) {
            blockClass = [blockClass superclass];
        }
    });

    isBlock = [item isKindOfClass:blockClass];

    return isBlock;
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
	void *pointer = SBLIsObjectType(type) ? [self placeholder] : NULL;
	return [NSValue value:&pointer withObjCType:type];
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

- (NSUInteger)hash {
    return [self.uuid hash];
}

@end
