//
//  CLCMultiproxierProxy.m
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCMultiproxierProxy.h"

struct objc_method_description CLCMethodDescriptionForSELInProtocol(Protocol *protocol, SEL sel) {
    struct objc_method_description description = protocol_getMethodDescription(protocol, sel, YES, YES);
    if (description.types) return description;
    description = protocol_getMethodDescription(protocol, sel, NO, YES);
    if (description.types) return description;
    return (struct objc_method_description){NULL, NULL};
}

BOOL CLCProtocolContainSel(Protocol *protocol, SEL sel) {
    return CLCMethodDescriptionForSELInProtocol(protocol, sel).types ? YES : NO;
}

@interface ImplemertorContext : NSObject

@property (nonatomic, weak) id implemertor;

@end

@implementation ImplemertorContext

@end

@interface CLCMultiproxierProxy ()

@property (nonatomic, strong) Protocol *protocol;

@property (nonatomic, strong) NSOrderedSet *implemertorContexts;

@end

@implementation CLCMultiproxierProxy

+ (instancetype)multiproxierForProtocol:(Protocol *)protocol withImplemertors:(NSArray *)implemertors {
    return [[super alloc] initWithProtocol:protocol withImplemertors:implemertors];
}

- (instancetype)initWithProtocol:(Protocol *)protocol withImplemertors:(NSArray *)implemertors {
    
    if (!implemertors.count) return nil;
    
    self.protocol = protocol;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:implemertors.count];
    
    __block BOOL oneConforms = NO;
    [implemertors enumerateObjectsUsingBlock:^(id  _Nonnull implemertor, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([implemertor conformsToProtocol:protocol]) {
            oneConforms = YES;
        }
        ImplemertorContext *context = [ImplemertorContext new];
        context.implemertor = implemertor;
        [array addObject:context];
        void *key = (__bridge void *)([NSString stringWithFormat:@"%p",self]);
        objc_setAssociatedObject(implemertor, key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
    
    NSAssert(oneConforms, @"You didn't attach any object that declares itself conforming to %@. At least one is needed.", NSStringFromProtocol(protocol));
    
    self.implemertorContexts = [NSOrderedSet orderedSetWithArray:array];
    
    if (!oneConforms) return nil;
    
    return self;
}

- (NSArray *)implemertors {
    NSMutableArray *array = [NSMutableArray array];
    for (ImplemertorContext *context in self.implemertorContexts) {
        id implemertor = context.implemertor;
        if (implemertor) {
            [array addObject:implemertor];
        }
    }
    return array;
}

- (BOOL)iCHindOfClass:(Class)aClass {
    for (Class tcls = object_getClass(self); tcls; tcls = class_getSuperclass(tcls)) {
        if (tcls == aClass) return YES;
    }
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [self class] == aClass;
}

+ (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return YES;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return protocol_conformsToProtocol(self.protocol, aProtocol);
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (!CLCProtocolContainSel(self.protocol, aSelector)) {
        return [super respondsToSelector:aSelector];
    }
    
    for (ImplemertorContext *context in self.implemertorContexts) {
        if ([context.implemertor respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    struct objc_method_description desctiption = CLCMethodDescriptionForSELInProtocol(self.protocol, sel);
    if (desctiption.name == NULL) {
        return nil;
    }
    return [NSMethodSignature signatureWithObjCTypes:desctiption.types];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector;
    if (!CLCProtocolContainSel(self.protocol, sel)) {
        [super forwardInvocation:invocation];
        return;
    }
    
    for (ImplemertorContext *context in self.implemertorContexts) {
        if ([context.implemertor respondsToSelector:sel]) {
            [invocation invokeWithTarget:context.implemertor];
        }
    }
}

@end
