//
//  CLCIndicatorProtocol.h
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#ifndef CLCIndicatorProtocol_h
#define CLCIndicatorProtocol_h
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CLCScrollViewIndicatorDirection) {
    CLCScrollViewIndicatorDirectionHorizontal,
    CLCScrollViewIndicatorDirectionVertical
};

typedef NS_ENUM(NSUInteger, CLCScrollViewIndicatorState) {
    CLCScrollViewIndicatorStateNormal,
    CLCScrollViewIndicatorStateSelected
};

@protocol CLCIndicatorProtocol <NSObject>

@property (nonatomic, assign, readonly) CLCScrollViewIndicatorDirection direction;

@property (nonatomic, assign, readonly) CLCScrollViewIndicatorState state;

@property (nonatomic, strong, readonly) NSValue *indicatorTranslation;

@property (nonatomic, assign) CGFloat indicatorSize;

@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, strong) UIColor *indicatorBackgroundColor;

@property (nonatomic, assign) BOOL indicatorRoundCorner;

@property (nonatomic, assign) BOOL indicatorDynamic;

@property (nonatomic, weak) UIScrollView *scrollView;

- (instancetype)initWithFrame:(CGRect)frame direction:(CLCScrollViewIndicatorDirection)direction;

- (void)updateIndicatorPosition:(CGFloat)position size:(CGFloat)size;

@end

#endif /* CLCIndicatorProtocol_h */
