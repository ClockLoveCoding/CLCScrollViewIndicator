//
//  UIScrollView+swizzleWillMoveToWindow.m
//  CLCScrollViewIndicator
//
//  Created by Clock.Hu on 2025/9/26.
//

#import "UIScrollView+swizzleWillMoveToWindow.h"
#import "UIScrollView+CLCIndicator.h"
#import "CLCMultiproxierProxy.h"
#import <objc/message.h>

@implementation UIScrollView (swizzleWillMoveToWindow)

- (void)clcIndicator_willMoveToWindow:(UIWindow *)newWindow {
    if (self.clc_showHorizontalScrollIndicator) {
        [self clc_addHorizontalIndicator];
    }
    if (self.clc_showVerticalScrollIndicator) {
        [self clc_addVerticalIndicator];
    }
    if (self.clc_indicatorDynamic) {
        [self clc_dynamicHiddenIndicator];
    }
    [self clcIndicator_willMoveToWindow:newWindow];
}

@end
