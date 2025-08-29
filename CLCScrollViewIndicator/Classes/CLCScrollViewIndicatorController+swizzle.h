//
//  CLCScrollViewIndicatorController+swizzle.h
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCScrollViewIndicatorController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLCScrollViewIndicatorController (swizzle)

- (void)swizzleFor:(__kindof UIScrollView <CLCScrollViewIndicatorProtocol>*)scrollView;

@end

NS_ASSUME_NONNULL_END
