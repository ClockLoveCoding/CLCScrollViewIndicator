//
//  CLCScrollViewIndicatorProtocol.h
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#ifndef CLCScrollViewIndicatorProtocol_h
#define CLCScrollViewIndicatorProtocol_h

#import "CLCIndicatorProtocol.h"

@class CLCScrollViewIndicatorController;

#define kScrollViewIndicatorDefaultColor [UIColor colorWithWhite:0 alpha:0.35]
#define kScrollViewIndicatorDefaultSize 3

@protocol CLCScrollViewIndicatorProtocol <NSObject>

@property (nonatomic, assign) CLCScrollViewIndicatorState clc_indicatorState;

@property (nonatomic, strong) CLCScrollViewIndicatorController *clc_indicatorController;

@property (nonatomic, assign) BOOL clc_showHorizontalScrollIndicator;

@property (nonatomic, assign) BOOL clc_showVerticalScrollIndicator;

@property (nonatomic, assign) CGFloat clc_indicatorSize;

@property (nonatomic, assign) UIEdgeInsets clc_indicatorInsets;

@property (nonatomic, strong) UIColor *clc_indicatorColor;

@property (nonatomic, strong) UIColor *clc_indicatorBackgroundColor;

@property (nonatomic, assign) BOOL clc_indicatorRoundCorner;

@property (nonatomic, assign) BOOL clc_indicatorDynamic;

@property (nonatomic, strong) UIView<CLCIndicatorProtocol> *clc_horizontalIndicator;

@property (nonatomic, strong) UIView<CLCIndicatorProtocol> *clc_verticalIndicator;

- (void)clc_updatedHorizontalIndicatorPosition:(CGFloat)position size:(CGFloat)size;

- (void)clc_updatedVerticalIndicatorPosition:(CGFloat)position size:(CGFloat)size;

- (void)clc_updatedCHIndicatorFrame;

- (void)clc_dynamicHiddenIndicator;

- (void)clc_dynamicShowIndicator;

@end

#endif /* CLCScrollViewIndicatorProtocol_h */
