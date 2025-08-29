//
//  CLCDebounceTask.h
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLCDebounceTask : NSObject

@property(class) dispatch_queue_t defaultQueue;

- (void)debounceTask:(void(^)(void))task oncePerDuration:(NSTimeInterval)durationThreshold;

- (void)debounceTask:(void(^)(void))task onQueue:(dispatch_queue_t)queue oncePerDuration:(NSTimeInterval)durationThreshold;

- (void)cancelTask;

@end

NS_ASSUME_NONNULL_END
