//
//  NSObject+CLCswizzleHelper.h
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CLCswizzleHelper)

+ (BOOL)clc_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_;

@end

NS_ASSUME_NONNULL_END
