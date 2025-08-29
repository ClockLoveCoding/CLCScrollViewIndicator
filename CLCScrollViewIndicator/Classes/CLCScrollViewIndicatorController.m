//
//  CLCScrollViewIndicatorController.m
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCScrollViewIndicatorController.h"
#import "CLCScrollViewIndicatorController+swizzle.h"
#import "CLCDebounceTask.h"

static void * CLCScrollViewIndicatorOffsetContext = &CLCScrollViewIndicatorOffsetContext;
static void * CLCScrollViewIndicatorFrameContext = &CLCScrollViewIndicatorFrameContext;
static void * CLCScrollViewIndicatorCenterContext = &CLCScrollViewIndicatorCenterContext;
static void * CLCScrollViewIndicatorBoundsContext = &CLCScrollViewIndicatorBoundsContext;
static void * CLCScrollViewIndicatorTranslationXContext = &CLCScrollViewIndicatorTranslationXContext;
static void * CLCScrollViewIndicatorTranslationYContext = &CLCScrollViewIndicatorTranslationYContext;

@interface CLCScrollViewIndicatorController()

@property (nonatomic) BOOL needUpdateFrame;

@property (nonatomic) CGRect lastFrame;

@property (nonatomic) BOOL hidIndicatorMark;

@property (nonatomic, strong) NSMutableArray *keys;

@property (nonatomic, strong) CLCDebounceTask *task;

@end

@implementation CLCScrollViewIndicatorController

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:CLCScrollViewIndicatorOffsetContext];
    [self.scrollView removeObserver:self forKeyPath:@"frame" context:CLCScrollViewIndicatorFrameContext];
    [self.scrollView removeObserver:self forKeyPath:@"center" context:CLCScrollViewIndicatorCenterContext];
    [self.scrollView removeObserver:self forKeyPath:@"bounds" context:CLCScrollViewIndicatorBoundsContext];
    if (self.scrollView.clc_horizontalIndicator) {
        [self.scrollView.clc_horizontalIndicator removeObserver:self forKeyPath:@"indicatorTranslation" context:CLCScrollViewIndicatorTranslationXContext];
    }

    if (self.scrollView.clc_verticalIndicator) {
        [self.scrollView.clc_verticalIndicator removeObserver:self forKeyPath:@"indicatorTranslation" context:CLCScrollViewIndicatorTranslationYContext];
    }
}

#pragma mark - private

- (void)executeOnce:(BOOL(^)(void))block forKey:(NSString *)key {
    if (!self.keys) self.keys = [NSMutableArray array];
    if ([self.keys containsObject:key]) return;
    if (block()) {
        [self.keys addObject:key];
    }
}

- (void)observerScrollView:(UIScrollView<CLCScrollViewIndicatorProtocol> *)scrollView {

    [self swizzleFor:scrollView];
    
    [self executeOnce:^{
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:CLCScrollViewIndicatorOffsetContext];

        [scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:CLCScrollViewIndicatorFrameContext];

        [scrollView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:CLCScrollViewIndicatorCenterContext];

        [scrollView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:CLCScrollViewIndicatorBoundsContext];
        return YES;
    } forKey:@"ObserverContent"];

    if (scrollView.clc_horizontalIndicator) {
        [self executeOnce:^{
            [scrollView.clc_horizontalIndicator addObserver:self forKeyPath:@"indicatorTranslation" options:NSKeyValueObservingOptionNew context:CLCScrollViewIndicatorTranslationXContext];
            return YES;
        } forKey:@"ObserverXTranslation"];
    }


    if (scrollView.clc_verticalIndicator) {
        [self executeOnce:^{
            [scrollView.clc_verticalIndicator addObserver:self forKeyPath:@"indicatorTranslation" options:NSKeyValueObservingOptionNew context:CLCScrollViewIndicatorTranslationYContext];
            return YES;
        }forKey:@"ObserverYTranslation"];
    }
}

- (void)updatedCHIndicatorFrameWithOffset:(CGPoint)offset {
    if (self.needUpdateFrame) {
        self.needUpdateFrame = NO;
        if (![self.scrollView respondsToSelector:@selector(clc_updatedCHIndicatorFrame)]) return;
        [self.scrollView clc_updatedCHIndicatorFrame];
    }
    [self calculateIndicatorFrameWithOffset:offset];
}

- (void)calculateIndicatorFrameWithOffset:(CGPoint)offset {
    if (self.scrollView.clc_showHorizontalScrollIndicator) {
        [self calculateHorizontalIndicatorFrameWithOffset:offset];
    }

    if (self.scrollView.clc_showVerticalScrollIndicator) {
        [self calculateVerticalIndicatorFrameWithOffset:offset];
    }
}

- (void)calculateHorizontalIndicatorFrameWithOffset:(CGPoint)offset {
    if (![self.scrollView respondsToSelector:@selector(clc_updatedHorizontalIndicatorPosition:size:)]) return;

    CGFloat containerWidth = self.scrollView.bounds.size.width;
    CGFloat subContainerWidth = self.scrollView.bounds.size.width - self.scrollView.clc_indicatorInsets.left - self.scrollView.clc_indicatorInsets.right;
    if (self.scrollView.clc_showVerticalScrollIndicator) {
        subContainerWidth -= CGRectGetWidth(self.scrollView.clc_verticalIndicator.frame);
    }
    CGFloat contentWidth = self.scrollView.contentSize.width + self.scrollView.contentInset.left + self.scrollView.contentInset.right;

    if (containerWidth >= contentWidth) {
        [self.scrollView clc_updatedHorizontalIndicatorPosition:0 size:0];
        return;
    }

    CGFloat indicatorHeight = self.scrollView.clc_indicatorSize;
    CGFloat minimumIndicatorWidth = indicatorHeight * 2.0;
    CGFloat indicatorWidth = MAX(pow(subContainerWidth, 2) / contentWidth, minimumIndicatorWidth);
    CGFloat widthDiff = subContainerWidth - indicatorWidth;
    CGFloat x1 = widthDiff;
    CGFloat x2 = contentWidth - containerWidth;

    CGFloat x = (x1 / x2) * offset.x;

    if (x < 0) {
        indicatorWidth += offset.x;
        x = 0;
    } else if (x > widthDiff) {
        x += (offset.x - x2);
        if (x > (subContainerWidth - minimumIndicatorWidth)) {
            x = subContainerWidth - minimumIndicatorWidth;
        }
        indicatorWidth = subContainerWidth - x;
    }

    [self.scrollView clc_updatedHorizontalIndicatorPosition:x size:MAX(minimumIndicatorWidth, indicatorWidth)];
}

- (void)calculateVerticalIndicatorFrameWithOffset:(CGPoint)offset {
    if (![self.scrollView respondsToSelector:@selector(clc_updatedVerticalIndicatorPosition:size:)]) return;

    CGFloat containerHeight = self.scrollView.bounds.size.height;
    CGFloat subContainerHeight = self.scrollView.bounds.size.height - self.scrollView.clc_indicatorInsets.top - self.scrollView.clc_indicatorInsets.bottom;
    if (self.scrollView.clc_showHorizontalScrollIndicator) {
        subContainerHeight -= CGRectGetHeight(self.scrollView.clc_horizontalIndicator.frame);
    }
    CGFloat contentHeight = self.scrollView.contentSize.height + self.scrollView.contentInset.bottom + self.scrollView.contentInset.top;

    if (containerHeight >= contentHeight) {
        [self.scrollView clc_updatedVerticalIndicatorPosition:0 size:0];
        return;
    }

    CGFloat indicatorWidth = self.scrollView.clc_indicatorSize;
    CGFloat minimumIndicatorHeight = indicatorWidth * 2.0;
    CGFloat indicatorHeight = MAX(pow(subContainerHeight, 2) / contentHeight, minimumIndicatorHeight);
    CGFloat heightDiff = subContainerHeight - indicatorHeight;
    CGFloat x1 = heightDiff;
    CGFloat x2 = contentHeight - containerHeight;

    CGFloat y = (x1 / x2) * offset.y;

    if (y < 0) {
        indicatorHeight += offset.y;
        y = 0;
    } else if (y > heightDiff) {
        y += (offset.y - x2);
        if (y > (subContainerHeight - minimumIndicatorHeight)) {
            y = subContainerHeight - minimumIndicatorHeight;
        }
        indicatorHeight = subContainerHeight - y;
    }

    [self.scrollView clc_updatedVerticalIndicatorPosition:y size:MAX(minimumIndicatorHeight, indicatorHeight)];
}

- (void)reConfigScrollViewWithHorizontalTranslation:(NSValue *)translation {
    if (!translation || ![translation isKindOfClass:NSValue.class]) {
        CGPoint offset = [self scrollViewOffsetXCriticalValueHandle];
        [self.scrollView setContentOffset:offset animated:YES];
        return;
    }
    CGPoint offset = [self calculateScrollViewOffsetXWithTranslation:translation];
    [self.scrollView setContentOffset:offset animated:NO];
}

- (CGPoint)calculateScrollViewOffsetXWithTranslation:(NSValue *)translation {

    CGFloat x = translation.CGPointValue.x;
    CGPoint offset = self.scrollView.contentOffset;
    if (x == 0) return offset;

    CGFloat containerWidth = self.scrollView.bounds.size.width;
    CGFloat contentWidth = self.scrollView.contentSize.width;

    x = contentWidth / containerWidth * x;

    offset.x += x;

    return offset;
}

- (CGPoint)scrollViewOffsetXCriticalValueHandle {
    CGPoint offset = self.scrollView.contentOffset;
    if (offset.x < 0) offset.x = 0;

    CGFloat scrollable = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offset.x > scrollable) offset.x = scrollable;
    return offset;
}

- (void)reConfigScrollViewWithVerticalTranslation:(NSValue *)translation {
    if (!translation || ![translation isKindOfClass:NSValue.class]) {
        CGPoint offset = [self scrollViewOffsetYCriticalValueHandle];
        [self.scrollView setContentOffset:offset animated:YES];
        return;
    }
    CGPoint offset = [self calculateScrollViewOffsetYWithTranslation:translation];
    [self.scrollView setContentOffset:offset animated:NO];
}

- (CGPoint)calculateScrollViewOffsetYWithTranslation:(NSValue *)translation {
    CGFloat y = translation.CGPointValue.y;
    CGPoint offset = self.scrollView.contentOffset;
    if (y == 0) return offset;

    CGFloat containerHeight = self.scrollView.bounds.size.height;
    CGFloat contentHeight = self.scrollView.contentSize.height;

    y = contentHeight / containerHeight * y;

    offset.y += y;

    return offset;
}

- (CGPoint)scrollViewOffsetYCriticalValueHandle {
    CGPoint offset = self.scrollView.contentOffset;
    if (offset.y < 0) offset.y = 0;

    CGFloat scrollable = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
    if (offset.y > scrollable) offset.y = scrollable;
    return offset;
}

- (void)sizeOrFrameChangedForScrollView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.needUpdateFrame = YES;
        [self updatedCHIndicatorFrameWithOffset:self.scrollView.contentOffset];
    });
}

- (void)prepareToHidIndicator {
    if (self.scrollView.clc_indicatorState == CLCScrollViewIndicatorStateSelected) {
        [self.task cancelTask];
        return;
    }
    self.hidIndicatorMark = true;
    __weak typeof (self) weakSelf = self;
    [self.task debounceTask:^{
        if (!weakSelf.hidIndicatorMark || weakSelf.scrollView.clc_indicatorState == CLCScrollViewIndicatorStateSelected) return;
        [UIView animateWithDuration:0.3 animations:^{
            if (!weakSelf.hidIndicatorMark || weakSelf.scrollView.clc_indicatorState == CLCScrollViewIndicatorStateSelected) return;
            [weakSelf.scrollView clc_dynamicHiddenIndicator];
        }];
    } oncePerDuration:1];
}

#pragma mark - UISCrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.hidIndicatorMark = NO;
    [self.scrollView clc_dynamicShowIndicator];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self prepareToHidIndicator];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    [self prepareToHidIndicator];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == CLCScrollViewIndicatorOffsetContext) {
        NSValue *value = [change objectForKey:NSKeyValueChangeNewKey];
        if (![value isKindOfClass:NSValue.class]) return;
        CGPoint conentOffset = value.CGPointValue;
        [self updatedCHIndicatorFrameWithOffset:conentOffset];
    } else if (context == CLCScrollViewIndicatorFrameContext || context == CLCScrollViewIndicatorCenterContext) {
        self.lastFrame = self.scrollView.frame;
        [self sizeOrFrameChangedForScrollView];
    } else if (context == CLCScrollViewIndicatorBoundsContext) {
        CGRect frame = self.scrollView.frame;
        if (CGRectEqualToRect(self.lastFrame, frame)) return;
        self.lastFrame = frame;
        [self sizeOrFrameChangedForScrollView];
    } else if (context == CLCScrollViewIndicatorTranslationXContext) {
        NSValue *value = [change objectForKey:NSKeyValueChangeNewKey];
        [self reConfigScrollViewWithHorizontalTranslation:value];
        if (!self.scrollView.clc_indicatorDynamic) return;
        [self prepareToHidIndicator];
    } else if (context == CLCScrollViewIndicatorTranslationYContext) {
        NSValue *value = [change objectForKey:NSKeyValueChangeNewKey];
        [self reConfigScrollViewWithVerticalTranslation:value];
        if (!self.scrollView.clc_indicatorDynamic) return;
        [self prepareToHidIndicator];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - setter

- (void)setScrollView:(UIScrollView<CLCScrollViewIndicatorProtocol> *)scrollView {
    if (_scrollView != scrollView) {
        _scrollView = scrollView;
    }
    [self observerScrollView:scrollView];
}

- (CLCDebounceTask *)task {
    if (!_task) {
        _task = [CLCDebounceTask new];
    }
    return _task;
}

@end
