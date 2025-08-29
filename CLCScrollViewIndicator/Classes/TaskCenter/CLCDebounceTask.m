//
//  CLCDebounceTask.m
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCDebounceTask.h"

static dispatch_queue_t CLCDebounceTaskDefaultQueue;

@interface CLCDebounceTask ()

@property (nonatomic, copy) dispatch_block_t task;

@end

@implementation CLCDebounceTask

- (void)debounceTask:(void(^)(void))task oncePerDuration:(NSTimeInterval)durationThreshold {
    [self debounceTask:task onQueue:CLCDebounceTask.defaultQueue oncePerDuration:durationThreshold];
}

- (void)debounceTask:(void(^)(void))task onQueue:(dispatch_queue_t)queue oncePerDuration:(NSTimeInterval)durationThreshold {
    NSParameterAssert(queue);
    NSParameterAssert(task);
    [self cancelTask];
    @synchronized(self) {
        self.task = dispatch_block_create(0, task);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durationThreshold * NSEC_PER_SEC)), queue, self.task);
    }
}

- (void)cancelTask {
    @synchronized(self) {
        if (!self.task) return;
        dispatch_block_cancel(self.task);
        self.task = nil;
    }
}

+ (void)initialize {
  if (self == [CLCDebounceTask class]) {
      CLCDebounceTaskDefaultQueue = dispatch_get_main_queue();
  }
}

+ (dispatch_queue_t)defaultQueue {
  @synchronized(self) {
    return CLCDebounceTaskDefaultQueue;
  }
}

+ (void)setDefaultQueue:(dispatch_queue_t)queue {
  NSParameterAssert(queue);

  @synchronized(self) {
      CLCDebounceTaskDefaultQueue = queue;
  }
}

@end
