//
//  CLCMultiproxierProxy.h
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define CLCMultiproxierForProtocol(__protocol__, ...) ((CLCMultiproxierProxy <__protocol__> *)[CLCMultiproxierProxy multiproxierForProtocol:@protocol(__protocol__) withImplemertors:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])])

NS_ASSUME_NONNULL_BEGIN

@interface CLCMultiproxierProxy : NSProxy

@property (nonatomic, strong, readonly) Protocol *protocol;

@property (nonatomic, strong, readonly) NSArray *implemertors;

+ (instancetype)multiproxierForProtocol:(Protocol *)protocol withImplemertors:(NSArray *)implemertors;

@end

NS_ASSUME_NONNULL_END
