//
//  CLCScrollViewIndicatorController+swizzle.m
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCScrollViewIndicatorController+swizzle.h"
#import "NSObject+CLCswizzleHelper.h"
#import "CLCMultiproxierProxy.h"

@implementation CLCScrollViewIndicatorController (swizzle)

- (void)swizzleFor:(__kindof UIScrollView <CLCScrollViewIndicatorProtocol>*)scrollView {
    if (!scrollView.clc_indicatorDynamic) {
        if (scrollView.delegate && [scrollView.delegate isKindOfClass:CLCMultiproxierProxy.class]) {
            CLCMultiproxierProxy *proxy = (CLCMultiproxierProxy *)scrollView.delegate;
            id delegate;
            for (id implemertor in proxy.implemertors) {
                if (![implemertor isEqual:self]) {
                    delegate = implemertor;
                    break;
                }
            }
            scrollView.delegate = delegate;
        }
        return;
    }
    Protocol *protocol;
    if ([self.scrollView isKindOfClass:UITableView.class]) {
        protocol = @protocol(UITableViewDelegate);
        [self swizzleTableView];
    } else if ([self.scrollView isKindOfClass:UICollectionView.class]) {
        protocol = @protocol(UICollectionViewDelegate);
        [self swizzleCollectionView];
    } else {
        protocol = @protocol(UIScrollViewDelegate);
        [self swizzleScrollview];
    }
    
    if (scrollView.delegate) {
        if ( [scrollView.delegate isKindOfClass:CLCMultiproxierProxy.class]) {
            CLCMultiproxierProxy *proxy = (CLCMultiproxierProxy *)scrollView.delegate;
            if (![proxy.implemertors containsObject:self]) {
                NSMutableArray *implemertors = [proxy.implemertors mutableCopy];
                [implemertors addObject:self];
                scrollView.delegate = [CLCMultiproxierProxy multiproxierForProtocol:proxy.protocol withImplemertors:implemertors];
            }
        } else {
            scrollView.delegate = [CLCMultiproxierProxy multiproxierForProtocol:protocol withImplemertors:@[scrollView.delegate, self]];
        }
    }
}

- (void)swizzleScrollview {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selector = NSSelectorFromString(@"indicator_setDelegate:");
        [UIScrollView clc_swizzleMethod:@selector(setDelegate:) withMethod:selector];
    });
}

- (void)swizzleTableView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selector = NSSelectorFromString(@"indicator_setDelegate:");
        [UITableView clc_swizzleMethod:@selector(setDelegate:) withMethod:selector];
    });
}

- (void)swizzleCollectionView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selector = NSSelectorFromString(@"indicator_setDelegate:");
        [UICollectionView clc_swizzleMethod:@selector(setDelegate:) withMethod:selector];
    });
}

@end
