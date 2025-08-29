//
//  CLCIndicator.h
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCIndicatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLCIndicator: UIView <CLCIndicatorProtocol>

@property (nonatomic, strong) UIColor *indicatorBackgroundColor;

@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, assign) CGFloat indicatorSize;

@property (nonatomic, assign) BOOL indicatorRoundCorner;

@property (nonatomic, assign) BOOL indicatorDynamic;

@end

NS_ASSUME_NONNULL_END
