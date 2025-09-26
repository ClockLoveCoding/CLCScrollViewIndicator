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
    
    [self swizzleMethods];
    
    Protocol *protocol;
    if ([self.scrollView isKindOfClass:UITableView.class]) {
        protocol = @protocol(UITableViewDelegate);
    } else if ([self.scrollView isKindOfClass:UICollectionView.class]) {
        protocol = @protocol(UICollectionViewDelegate);
    } else {
        protocol = @protocol(UIScrollViewDelegate);
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

- (void)swizzleMethods {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([self.scrollView isKindOfClass:UITableView.class]) {
            [self swizzleTableViewDelegate];
        } else if ([self.scrollView isKindOfClass:UICollectionView.class]) {
            [self swizzleCollectionViewDelegate];
        } else {
            [self swizzleScrollviewDelegate];
        }
        
        SEL selector = NSSelectorFromString(@"clcIndicator_willMoveToWindow:");
        [UIScrollView clc_swizzleMethod:@selector(willMoveToWindow:) withMethod:selector];
    });
}

- (void)swizzleScrollviewDelegate {
    SEL selector = NSSelectorFromString(@"clcIndicator_setDelegate:");
    [UIScrollView clc_swizzleMethod:@selector(setDelegate:) withMethod:selector];
}

- (void)swizzleTableViewDelegate {
    SEL selector = NSSelectorFromString(@"clcIndicator_setDelegate:");
    [UITableView clc_swizzleMethod:@selector(setDelegate:) withMethod:selector];
}

- (void)swizzleCollectionViewDelegate {
    SEL selector = NSSelectorFromString(@"clcIndicator_setDelegate:");
    [UICollectionView clc_swizzleMethod:@selector(setDelegate:) withMethod:selector];
}

@end
