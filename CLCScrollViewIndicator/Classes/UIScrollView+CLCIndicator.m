//
//  UIScrollView+CLCIndicator.m
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "UIScrollView+CLCIndicator.h"
#import "CLCIndicator.h"
#import "CLCScrollViewIndicatorController.h"
#import <objc/runtime.h>

@interface UIScrollView()

@property (nonatomic, strong) CLCScrollViewIndicatorController *indicatorController;

@property (nonatomic, strong) CLCIndicator *clc_horizontalIndicator;

@property (nonatomic, strong) CLCIndicator *clc_verticalIndicator;

@end

@implementation UIScrollView (CLCIndicator)

@dynamic clc_indicatorState;

#pragma mark - private

- (void)clc_addHorizontalIndicator {
    [self clc_prepareForIndicator];
    
    if (!self.superview) return;
    
    if (self.clc_horizontalIndicator) {
        [self clc_horizontalIndicatorConfiguration];
        return;
    }
    
    CLCIndicator *indicator = [[CLCIndicator alloc] initWithFrame:CGRectZero direction:CLCScrollViewIndicatorDirectionHorizontal];
    self.clc_horizontalIndicator = indicator;
    [self.superview addSubview:indicator];
    
    [self clc_horizontalIndicatorConfiguration];
}

- (void)clc_horizontalIndicatorConfiguration {
    CGFloat indicatorSize = self.clc_indicatorSize;
    CGFloat height = indicatorSize * 2;
    CGFloat y = CGRectGetMaxY(self.frame) - height*1.3;
    UIEdgeInsets insets = self.clc_indicatorInsets;
    CGFloat width = self.frame.size.width - insets.right - insets.left;
    if (self.clc_showVerticalScrollIndicator) {
        width -= height;
    }
    CGRect frame = CGRectMake(self.frame.origin.x + insets.left, y - insets.bottom, width, height);
    self.clc_horizontalIndicator.indicatorRoundCorner = self.clc_indicatorRoundCorner;
    self.clc_horizontalIndicator.indicatorDynamic = self.clc_indicatorDynamic;
    self.clc_horizontalIndicator.indicatorSize = indicatorSize;
    self.clc_horizontalIndicator.indicatorColor = self.clc_indicatorColor;
    self.clc_horizontalIndicator.indicatorBackgroundColor = self.clc_indicatorBackgroundColor;
    self.clc_horizontalIndicator.frame = frame;
    
    self.clc_horizontalIndicator.scrollView = self;
}

- (void)clc_removeHorizontalIndicator {
    if (!self.clc_horizontalIndicator) return;
    [self.clc_horizontalIndicator removeFromSuperview];
    if (!self.clc_showVerticalScrollIndicator) {
        self.indicatorController = nil;
    }
    self.clc_horizontalIndicator = nil;
}

- (void)clc_addVerticalIndicator {
    [self clc_prepareForIndicator];
    
    if (!self.superview) return;
    
    if (self.clc_verticalIndicator) {
        [self clc_verticalIndicatorConfiguration];
        return;
    }
    
    CLCIndicator *indicator = [[CLCIndicator alloc] initWithFrame:CGRectZero direction:CLCScrollViewIndicatorDirectionVertical];
    self.clc_verticalIndicator = indicator;
    [self.superview addSubview:indicator];
    
    [self clc_verticalIndicatorConfiguration];
}

- (void)clc_verticalIndicatorConfiguration {
    CGFloat indicatorSize = self.clc_indicatorSize;
    CGFloat width = indicatorSize * 2;
    CGFloat x = CGRectGetMaxX(self.frame) - width*1.3;
    UIEdgeInsets insets = self.clc_indicatorInsets;
    CGFloat height = self.frame.size.height - insets.bottom - insets.top;
    if (self.clc_showHorizontalScrollIndicator) {
        height -= width;
    }
    CGRect frame = CGRectMake(x - insets.right, self.frame.origin.y + insets.top, width, height);
    self.clc_verticalIndicator.frame = frame;
    self.clc_verticalIndicator.indicatorRoundCorner = self.clc_indicatorRoundCorner;
    self.clc_verticalIndicator.indicatorDynamic = self.clc_indicatorDynamic;
    self.clc_verticalIndicator.indicatorSize = indicatorSize;
    self.clc_verticalIndicator.indicatorColor = self.clc_indicatorColor;
    self.clc_verticalIndicator.indicatorBackgroundColor = self.clc_indicatorBackgroundColor;
    
    self.clc_verticalIndicator.scrollView = self;
    self.clc_indicatorController.scrollView = self;
}

- (void)clc_removeVerticalIndicator {
    if (!self.clc_verticalIndicator) return;
    [self.clc_verticalIndicator removeFromSuperview];
    if (!self.clc_showHorizontalScrollIndicator) {
        self.clc_indicatorController = nil;
    }
    self.clc_verticalIndicator = nil;
}

- (void)clc_prepareForIndicator {
    if (!self.clc_indicatorController) {
        self.clc_indicatorController = [CLCScrollViewIndicatorController new];
        self.clc_indicatorController.scrollView = self;
    };
}


#pragma mark - CLCScrollViewIndicatorProtocol

- (void)clc_updatedHorizontalIndicatorPosition:(CGFloat)position size:(CGFloat)size {
    [self.clc_horizontalIndicator updateIndicatorPosition:position size:size];
}

- (void)clc_updatedVerticalIndicatorPosition:(CGFloat)position size:(CGFloat)size {
    [self.clc_verticalIndicator updateIndicatorPosition:position size:size];
}

- (void)clc_updatedCHIndicatorFrame {
    if (self.clc_showHorizontalScrollIndicator) {
        [self clc_horizontalIndicatorConfiguration];
    }
    if (self.clc_showVerticalScrollIndicator) {
        [self clc_verticalIndicatorConfiguration];
    }
}

- (void)clc_dynamicHiddenIndicator {
    if (self.clc_verticalIndicator) {
        [self.clc_verticalIndicator dynamicHid];
    }
    if (self.clc_horizontalIndicator) {
        [self.clc_horizontalIndicator dynamicHid];
    }
}

- (void)clc_hiddenIndicatorWithoutAnimaiton {
    if (self.clc_verticalIndicator) {
        [self.clc_verticalIndicator hidWithoutAnimation];
    }
    if (self.clc_horizontalIndicator) {
        [self.clc_horizontalIndicator hidWithoutAnimation];
    }
}

- (void)clc_dynamicShowIndicator {
    if (self.clc_verticalIndicator) {
        [self.clc_verticalIndicator dynamicShow];
    }
    if (self.clc_horizontalIndicator) {
        [self.clc_horizontalIndicator dynamicShow];
    }
}

- (CLCScrollViewIndicatorState)clc_indicatorState {
    if (self.clc_verticalIndicator.state == CLCScrollViewIndicatorStateSelected) return CLCScrollViewIndicatorStateSelected;
    if (self.clc_horizontalIndicator.state == CLCScrollViewIndicatorStateSelected) return CLCScrollViewIndicatorStateSelected;
    return CLCScrollViewIndicatorStateNormal;
}

#pragma mark - setter & getter

- (void)setClc_showHorizontalScrollIndicator:(BOOL)clc_showHorizontalScrollIndicator {
    if (clc_showHorizontalScrollIndicator) {
        self.showsHorizontalScrollIndicator = NO;
        [self clc_addHorizontalIndicator];
    } else {
        [self clc_removeHorizontalIndicator];
    }
    objc_setAssociatedObject(self, @selector(clc_showHorizontalScrollIndicator), @(clc_showHorizontalScrollIndicator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)clc_showHorizontalScrollIndicator {
    NSNumber *show = objc_getAssociatedObject(self, @selector(clc_showHorizontalScrollIndicator));
    return show.boolValue;
}

- (void)setClc_showVerticalScrollIndicator:(BOOL)clc_showVerticalScrollIndicator {
    if (clc_showVerticalScrollIndicator) {
        self.showsVerticalScrollIndicator = NO;
        [self clc_addVerticalIndicator];
    } else {
        [self clc_removeVerticalIndicator];
    }
    objc_setAssociatedObject(self, @selector(clc_showVerticalScrollIndicator), @(clc_showVerticalScrollIndicator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)clc_showVerticalScrollIndicator {
    NSNumber *show = objc_getAssociatedObject(self, @selector(clc_showVerticalScrollIndicator));
    return show.boolValue;
}

- (void)setClc_indicatorController:(CLCScrollViewIndicatorController *)controller {
    objc_setAssociatedObject(self, @selector(clc_indicatorController), controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLCScrollViewIndicatorController *)clc_indicatorController {
    CLCScrollViewIndicatorController *controller = objc_getAssociatedObject(self, @selector(clc_indicatorController));
    return controller;
}

- (void)setClc_horizontalIndicator:(CLCIndicator *)clc_horizontalIndicator {
    objc_setAssociatedObject(self, @selector(clc_horizontalIndicator), clc_horizontalIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLCIndicator *)clc_horizontalIndicator {
    return objc_getAssociatedObject(self, @selector(clc_horizontalIndicator));
}

- (void)setClc_verticalIndicator:(CLCIndicator *)clc_verticalIndicator {
    objc_setAssociatedObject(self, @selector(clc_verticalIndicator), clc_verticalIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLCIndicator *)clc_verticalIndicator {
    return objc_getAssociatedObject(self, @selector(clc_verticalIndicator));
}

- (void)setClc_indicatorInsets:(UIEdgeInsets)indicatorInsets {
    objc_setAssociatedObject(self, @selector(clc_indicatorInsets), @(indicatorInsets), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)clc_indicatorInsets {
    NSValue *value = objc_getAssociatedObject(self, @selector(clc_indicatorInsets));
    if (!value) return UIEdgeInsetsZero;
    return value.UIEdgeInsetsValue;
}

- (void)setClc_indicatorSize:(CGFloat)indicatorSize {
    objc_setAssociatedObject(self, @selector(clc_indicatorSize), @(indicatorSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)clc_indicatorSize {
    NSNumber *value = objc_getAssociatedObject(self, @selector(clc_indicatorSize));
    if (!value) return kScrollViewIndicatorDefaultSize;
    return value.floatValue;
}

- (void)setClc_indicatorRoundCorner:(BOOL)indicatorRoundCorner {
    objc_setAssociatedObject(self, @selector(clc_indicatorRoundCorner), @(indicatorRoundCorner), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)clc_indicatorRoundCorner {
    NSNumber *value = objc_getAssociatedObject(self, @selector(clc_indicatorRoundCorner));
    if (!value) return YES;
    return value.boolValue;
}

- (void)setClc_indicatorDynamic:(BOOL)indicatorDynamic {
    objc_setAssociatedObject(self, @selector(clc_indicatorDynamic), @(indicatorDynamic), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.clc_indicatorController) return;
    if (indicatorDynamic) {
        [self clc_dynamicHiddenIndicator];
    } else {
        [self clc_dynamicShowIndicator];
    }
    self.clc_indicatorController.scrollView = self;
}

- (BOOL)clc_indicatorDynamic {
    NSNumber *value = objc_getAssociatedObject(self, @selector(clc_indicatorDynamic));
    if (!value) return YES;
    return value.boolValue;
}

- (void)setClc_indicatorColor:(UIColor *)indicatorColor {
    objc_setAssociatedObject(self, @selector(clc_indicatorColor), indicatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)clc_indicatorColor {
    UIColor *value = objc_getAssociatedObject(self, @selector(clc_indicatorColor));
    if (!value) {
        value = kScrollViewIndicatorDefaultColor;
        objc_setAssociatedObject(self, @selector(clc_indicatorColor), kScrollViewIndicatorDefaultColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
}

- (void)setClc_indicatorBackgroundColor:(UIColor *)indicatorBackgroundColor {
    objc_setAssociatedObject(self, @selector(clc_indicatorBackgroundColor), indicatorBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)clc_indicatorBackgroundColor {
    UIColor *value = objc_getAssociatedObject(self, @selector(clc_indicatorBackgroundColor));
    return value;
}

@end
