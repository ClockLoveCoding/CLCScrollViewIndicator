//
//  UIScrollView+CLCIndicator.h
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCScrollViewIndicatorProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (CLCIndicator) <CLCScrollViewIndicatorProtocol>

@property (nonatomic, strong) CLCScrollViewIndicatorController *indicatorController;

@property (nonatomic, assign) IBInspectable BOOL clc_showHorizontalScrollIndicator;

@property (nonatomic, assign) IBInspectable BOOL clc_showVerticalScrollIndicator;

@property (nonatomic, assign) IBInspectable CGFloat clc_indicatorSize;

@property (nonatomic, assign) IBInspectable UIEdgeInsets clc_indicatorInsets;

@property (nonatomic, strong) IBInspectable UIColor *clc_indicatorColor;

@property (nonatomic, strong) IBInspectable UIColor *clc_indicatorBackgroundColor;

@property (nonatomic, assign) IBInspectable BOOL clc_indicatorRoundCorner;

@property (nonatomic, assign) IBInspectable BOOL clc_indicatorDynamic;

- (void)clc_addHorizontalIndicator;
- (void)clc_addVerticalIndicator;
- (void)clc_dynamicHiddenIndicator;

@end

NS_ASSUME_NONNULL_END
