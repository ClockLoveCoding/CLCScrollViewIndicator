//
//  CLCScrollViewIndicatorController.h
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCScrollViewIndicatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLCScrollViewIndicatorController : NSObject<UIScrollViewDelegate, UITableViewDelegate, UICollectionViewDelegate>

@property (nonatomic, weak) UIScrollView<CLCScrollViewIndicatorProtocol> *scrollView;

@end

NS_ASSUME_NONNULL_END
