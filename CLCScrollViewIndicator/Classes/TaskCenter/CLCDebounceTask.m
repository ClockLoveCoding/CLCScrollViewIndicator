//
//  CLCDebounceTask.m
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCDebounceTask.h"
#import <os/lock.h>

static dispatch_queue_t CLCDebounceTaskDefaultQueue;

@interface CLCDebounceTask () {
    os_unfair_lock _lock;
    uint32_t       _token;
    dispatch_block_t _holder;
}
@end

@implementation CLCDebounceTask

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = OS_UNFAIR_LOCK_INIT;
        _token = 0;
        _holder = nil;
    }
    return self;
}

- (void)debounceTask:(dispatch_block_t)task oncePerDuration:(NSTimeInterval)durationThreshold {
    [self debounceTask:task onQueue:CLCDebounceTaskDefaultQueue oncePerDuration:durationThreshold];
}

- (void)debounceTask:(dispatch_block_t)task
             onQueue:(dispatch_queue_t)queue
      oncePerDuration:(NSTimeInterval)durationThreshold {
    NSParameterAssert(queue);
    NSParameterAssert(task);

    [self cancelTask];

    os_unfair_lock_lock(&_lock);
    uint32_t thisToken = ++_token;
    _holder = [task copy];
    os_unfair_lock_unlock(&_lock);

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                            (int64_t)(durationThreshold * NSEC_PER_SEC));
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(popTime, queue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        os_unfair_lock_lock(&(strongSelf->_lock));
        if (thisToken != strongSelf->_token) {
            os_unfair_lock_unlock(&(strongSelf->_lock));
            return;
        }
        dispatch_block_t exec = strongSelf->_holder;
        strongSelf->_holder = nil;
        os_unfair_lock_unlock(&(strongSelf->_lock));
        if (exec) exec();
    });
}

- (void)cancelTask {
    os_unfair_lock_lock(&_lock);
    _token++;
    _holder = nil;
    os_unfair_lock_unlock(&_lock);
}

+ (void)initialize {
    if (self == [CLCDebounceTask class]) {
        CLCDebounceTaskDefaultQueue = dispatch_get_main_queue();
    }
}

+ (dispatch_queue_t)defaultQueue {
    return CLCDebounceTaskDefaultQueue;
}

+ (void)setDefaultQueue:(dispatch_queue_t)queue {
    NSParameterAssert(queue);
    CLCDebounceTaskDefaultQueue = queue;
}

@end
