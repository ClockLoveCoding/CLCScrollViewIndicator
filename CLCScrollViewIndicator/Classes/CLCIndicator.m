//
//  CLCIndicator.m
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCIndicator.h"

@interface IndicatorContainer : UIView

@end

@implementation IndicatorContainer

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect frame = self.bounds;
    CGRect rect = CGRectMake(frame.origin.x-10, frame.origin.y-10, frame.size.width+20, frame.size.height+20);
    if(CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}

@end


@interface CLCIndicator()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) IndicatorContainer *indicatorContainer;

@property (nonatomic, strong) UIView *indicator;

@property (nonatomic, assign) BOOL onLongPress;

@property (nonatomic, strong) NSValue *indicatorTranslation;

@property (nonatomic, assign) CLCScrollViewIndicatorState state;

@property (nonatomic, assign) CLCScrollViewIndicatorDirection direction;

@property (nonatomic, assign) CGFloat originalWidth;

@property (nonatomic, assign) CGFloat originalHeight;

@property (nonatomic, strong) NSLayoutConstraint *backgroundSizeCons;

@property (nonatomic, strong) NSLayoutConstraint *backgroundCenterCons;

@property (nonatomic, strong) NSLayoutConstraint *indicatorSizeCons;

@end

@implementation CLCIndicator

@synthesize scrollView;


#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame direction:(CLCScrollViewIndicatorDirection)direction  {
    self = [super initWithFrame:frame];
    if (self) {
        self.direction = direction;
        self.originalWidth = frame.size.width;
        self.originalHeight = frame.size.height;
        [self setupUI];
        [self addGestureRecognizer];
    }
    return self;
}

#pragma mark - override

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.originalWidth = frame.size.width;
    self.originalHeight = frame.size.height;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return nil;
    CGPoint subPoint = [self convertPoint:point toView:self.indicatorContainer];
    if ([self.indicatorContainer pointInside:subPoint withEvent:event]) return self.indicatorContainer;
    return nil;
}

#pragma mark - public

- (void)updateIndicatorPosition:(CGFloat)position size:(CGFloat)size {
    if (isnan(position) || isnan(size)) return;
    if (position <= 0 && size <= 0) {
        self.indicator.hidden = YES;
        return;
    }
    self.indicator.hidden = NO;
    
    CGRect frame = self.indicatorContainer.frame;
    if (self.direction == CLCScrollViewIndicatorDirectionVertical) {
        frame.size.height = MAX(size, self.indicatorSizeCons.constant);
        if (position + frame.size.height > CGRectGetHeight(self.frame)) {
            position -= position + frame.size.height - CGRectGetHeight(self.frame);
        }
        frame.origin.y = position;
        frame.size.width = MAX(self.originalWidth, frame.size.width);
    } else {
        frame.size.width = MAX(size, self.indicatorSizeCons.constant);
        if (position + frame.size.width > CGRectGetWidth(self.frame)) {
            position -= position + frame.size.width - CGRectGetWidth(self.frame);
        }
        frame.origin.x = position;
        frame.size.height = MAX(self.originalHeight, frame.size.height);
    }
    self.indicatorContainer.frame = frame;
}

- (void)dynamicHid {
    if (!self.indicatorDynamic) return;
    if (self.scrollView.isTracking) return;
    if (self.state == CLCScrollViewIndicatorStateSelected) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorContainer.alpha = 0;
        self.backgroundView.alpha = 0;
    }];
}

- (void)hidWithoutAnimation {
    self.indicatorContainer.alpha = 0;
    self.backgroundView.alpha = 0;
}

- (void)dynamicShow {
    self.indicatorContainer.alpha = 1;
    self.backgroundView.alpha = 1;
}

#pragma mark - private

- (void)addGestureRecognizer {
    UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressEvents:)];
    lp.minimumPressDuration = 0.1;
    lp.delegate = self;
    [self.indicatorContainer addGestureRecognizer:lp];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanEvents:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [self.indicatorContainer addGestureRecognizer:pan];
}

- (void)setupUI {
    [self addSubview:self.backgroundView];
    [self addSubview:self.indicatorContainer];
    [self.indicatorContainer addSubview:self.indicator];
    
    [self layoutSubviewsForDirection];
}

- (void)layoutSubviewsForDirection {
    switch (self.direction) {
        case CLCScrollViewIndicatorDirectionHorizontal:
            [self layoutSubviewsForHorizontalDirection];
            break;
            
        case CLCScrollViewIndicatorDirectionVertical:
            [self layoutSubviewsForVerticalDirection];
            break;
    }
}

- (void)layoutSubviewsForHorizontalDirection {
    
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundSizeCons = [self.backgroundView.heightAnchor constraintEqualToConstant:self.indicatorSize];
    self.backgroundCenterCons = [self.backgroundView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    [NSLayoutConstraint activateConstraints:@[
        self.backgroundCenterCons,
        [self.backgroundView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.backgroundView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
        self.backgroundSizeCons
    ]];
    
    self.indicatorContainer.frame = CGRectMake(0, 0, 100, self.originalHeight);
    
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.indicatorSize];
    NSLayoutConstraint *rightCons = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.indicatorContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *cneterYCons = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.indicatorContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *leftCons = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.indicatorContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    [self.indicatorContainer addConstraints:@[
        cneterYCons,
        leftCons,
        rightCons
    ]];
    [self.indicator addConstraints:@[
        heightCons
    ]];
    
    self.indicatorSizeCons = heightCons;
}

- (void)layoutSubviewsForVerticalDirection {
    
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backgroundSizeCons = [self.backgroundView.widthAnchor constraintEqualToConstant:self.indicatorSize];
    self.backgroundCenterCons = [self.backgroundView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    [NSLayoutConstraint activateConstraints:@[
        self.backgroundCenterCons,
        [self.backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        self.backgroundSizeCons
    ]];
    
    self.indicatorContainer.frame = CGRectMake(0, 0, self.originalWidth, 100);
    
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.indicatorSize];
    NSLayoutConstraint *bottomCons = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.indicatorContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *topCons = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.indicatorContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerXCons = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.indicatorContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.indicatorContainer addConstraints:@[
        topCons,
        centerXCons,
        bottomCons
    ]];
    [self.indicator addConstraints:@[
        widthCons
    ]];
    
    self.indicatorSizeCons = widthCons;
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - events

- (void)onPanEvents:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    if (!self.onLongPress) return;
    
    UIView *piece = panGestureRecognizer.view;
    
    if (!piece) return;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:piece.superview];
        self.indicatorTranslation = @(translation);
        [panGestureRecognizer setTranslation:CGPointZero inView:piece.superview];
    }
}

- (void)onLongPressEvents:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.onLongPress = YES;
        self.state = CLCScrollViewIndicatorStateSelected;
    } else if (longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateFailed) {
        self.onLongPress = NO;
        self.state = CLCScrollViewIndicatorStateNormal;
        self.indicatorTranslation = nil;
    }
}

- (void)enlargeShape {
    
    CGFloat increase = self.indicatorSizeCons.constant * (3.0 / 2);
    CGRect frame = self.indicatorContainer.frame;
    CGFloat cornerRadius = 0;
    
    switch (self.direction) {
        case CLCScrollViewIndicatorDirectionHorizontal:{
            frame.origin.y -= increase;
            frame.size.height += increase;
        }
            break;
            
        case CLCScrollViewIndicatorDirectionVertical: {
            frame.origin.x -= increase;
            frame.size.width += increase;
        }
            break;
    }
    
    self.backgroundSizeCons.constant += increase;
    self.backgroundCenterCons.constant -= increase * 0.5;
    
    self.indicatorSizeCons.constant += increase;
    if (self.indicatorRoundCorner) {
        cornerRadius = self.indicatorSizeCons.constant * 0.5;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorContainer.frame = frame;
        self.indicator.layer.cornerRadius = cornerRadius;
        
        [self layoutIfNeeded];
    }];
}

- (void)reShape {
    
    CGRect frame = self.indicatorContainer.frame;
    CGFloat cornerRadius = 0;
    
    switch (self.direction) {
        case CLCScrollViewIndicatorDirectionHorizontal:{
            frame.size.height = self.originalHeight;
            frame.origin.y = 0;
        }
            break;
            
        case CLCScrollViewIndicatorDirectionVertical: {
            frame.size.width = self.originalWidth;
            frame.origin.x = 0;
        }
            break;
    }
    
    self.indicatorSizeCons.constant = self.indicatorSize;
    if (self.indicatorRoundCorner) {
        cornerRadius = self.indicatorSizeCons.constant * 0.5;
    }
    
    self.backgroundSizeCons.constant = self.indicatorSize;
    self.backgroundCenterCons.constant = 0;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorContainer.frame = frame;
        self.indicator.layer.cornerRadius = cornerRadius;
        
        [self layoutIfNeeded];
    }];
}

#pragma mark - setter

- (void)setState:(CLCScrollViewIndicatorState)state {
    _state = state;
    switch (state) {
        case CLCScrollViewIndicatorStateNormal:
            [self reShape];
            break;
            
        case CLCScrollViewIndicatorStateSelected:
            [self enlargeShape];
            break;
    }
}

- (void)setIndicatorBackgroundColor:(UIColor *)indicatorBackgroundColor {
    if (!indicatorBackgroundColor) return;
    _indicatorBackgroundColor = indicatorBackgroundColor;
    self.backgroundView.backgroundColor = indicatorBackgroundColor;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor =  indicatorColor;
    self.indicator.backgroundColor = indicatorColor;
}

- (void)setIndicatorSize:(CGFloat)indicatorSize {
    _indicatorSize = indicatorSize;
    
    if (self.indicatorRoundCorner) {
        self.indicator.layer.cornerRadius = indicatorSize * 0.5;
    }
    
    self.indicatorSizeCons.constant = indicatorSize;
    self.backgroundSizeCons.constant = indicatorSize;
}

- (void)setIndicatorRoundCorner:(BOOL)indicatorRoundCorner {
    
    _indicatorRoundCorner = indicatorRoundCorner;
    
    if (indicatorRoundCorner) {
        self.indicator.layer.cornerRadius = self.indicatorSize * 0.5;
    } else {
        self.indicator.layer.cornerRadius = 0;
    }
    
}

#pragma mark - getter

- (UIView *)indicator {
    if (!_indicator) {
        UIView *indicator = [UIView new];
        indicator.backgroundColor = self.indicatorColor;
        
        if (self.indicatorRoundCorner) {
            indicator.layer.cornerRadius = self.indicatorSize * 0.5;
        }
        
        _indicator = indicator;
    }
    return _indicator;
}

- (IndicatorContainer *)indicatorContainer {
    if (!_indicatorContainer) {
        IndicatorContainer *view = [IndicatorContainer new];
        _indicatorContainer = view;
    }
    return _indicatorContainer;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        UIView *view = [UIView new];
        _backgroundView = view;
    }
    return _backgroundView;
}

@end
