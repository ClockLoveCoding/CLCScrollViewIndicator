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
    if (![self isMemberOfClass:UIScrollView.class]) {
        struct objc_super target = {
            .super_class = class_getSuperclass(self.class),
            .receiver = self,
        };
        NSMethodSignature *(*messageSendSuper)(struct objc_super *, SEL, id) = (__typeof__(messageSendSuper))objc_msgSendSuper;
        messageSendSuper(&target, @selector(clcIndicator_willMoveToWindow:), newWindow);
    } else {
        [self clcIndicator_willMoveToWindow:newWindow];
    }
}

@end
