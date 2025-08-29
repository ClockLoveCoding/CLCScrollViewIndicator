#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CLCIndicator.h"
#import "CLCIndicatorProtocol.h"
#import "CLCScrollViewIndicator.h"
#import "CLCScrollViewIndicatorController+swizzle.h"
#import "CLCScrollViewIndicatorController.h"
#import "CLCScrollViewIndicatorProtocol.h"
#import "CLCMultiproxierProxy.h"
#import "NSObject+CLCswizzleHelper.h"
#import "CLCDebounceTask.h"
#import "UIScrollView+CLCIndicator.h"
#import "UIScrollView+swizzleDelegate.h"

FOUNDATION_EXPORT double CLCScrollViewIndicatorVersionNumber;
FOUNDATION_EXPORT const unsigned char CLCScrollViewIndicatorVersionString[];

