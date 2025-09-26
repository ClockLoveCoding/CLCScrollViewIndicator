//
//  UIScrollView+swizzleDelegate.m
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "UIScrollView+swizzleDelegate.h"
#import "UIScrollView+CLCIndicator.h"
#import "CLCMultiproxierProxy.h"
#import <objc/message.h>

@implementation UIScrollView (swizzleDelegate)

- (void)clcIndicator_setDelegate:(id <UIScrollViewDelegate>)delegate {
    if (![self isMemberOfClass:UIScrollView.class]) {
        struct objc_super target = {
            .super_class = class_getSuperclass(self.class),
            .receiver = self,
        };
        NSMethodSignature *(*messageSendSuper)(struct objc_super *, SEL, id) = (__typeof__(messageSendSuper))objc_msgSendSuper;
        messageSendSuper(&target, @selector(clcIndicator_setDelegate:), delegate);
    } else {
        if ((self.clc_showVerticalScrollIndicator || self.clc_showHorizontalScrollIndicator) && self.clc_indicatorDynamic && self.clc_indicatorController) {
            delegate = CLCMultiproxierForProtocol(UIScrollViewDelegate, delegate, self.clc_indicatorController);
        }
        [self clcIndicator_setDelegate:delegate];
    }
}

@end

@implementation UITableView (swizzleDelegate)

- (void)clcIndicator_setDelegate:(id <UITableViewDelegate>)delegate {
    if ((self.clc_showVerticalScrollIndicator || self.clc_showHorizontalScrollIndicator) && self.clc_indicatorDynamic && self.clc_indicatorController) {
        delegate = CLCMultiproxierForProtocol(UITableViewDelegate, delegate, self.clc_indicatorController);
    }
    [self clcIndicator_setDelegate:delegate];
}

@end

@implementation UICollectionView (swizzleDelegate)

- (void)clcIndicator_setDelegate:(id <UICollectionViewDelegate>)delegate {
    if ((self.clc_showVerticalScrollIndicator || self.clc_showHorizontalScrollIndicator) && self.clc_indicatorDynamic && self.clc_indicatorController) {
        delegate = CLCMultiproxierForProtocol(UICollectionViewDelegate, delegate, self.clc_indicatorController);
    }
    [self clcIndicator_setDelegate:delegate];
}

@end
