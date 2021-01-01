//
//  HiScrollView.h
//  ScrollTest
//
//  Created by four on 2020/12/23.
//

#import "HiScrollViewPublic.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIScrollView (HiScrollView)

/// 只能设置一次
- (void)hi_scrollWithScrollDirection:(HiScrollViewDirection)direction;

@end

NS_ASSUME_NONNULL_END
