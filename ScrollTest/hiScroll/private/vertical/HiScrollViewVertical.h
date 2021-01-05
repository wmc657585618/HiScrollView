//
//  HiScrollViewVertical.h
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HiScrollViewVertical)

/// 控制垂直滚动的方法
- (void)controlScrollForVertical:(CGFloat)offset state:(UIGestureRecognizerState)state;

/* 在垂直方向上可以处理滚动 */
- (BOOL)canChangeVerticalOffset:(CGFloat)offset size:(CGFloat)size;

- (void)resetVerticalScrollView:(UIScrollView *)scrollView;

- (UIDynamicItemBehavior *)addInertialBehaviorWithVerticalVelocity:(CGFloat)velocity;

@end

NS_ASSUME_NONNULL_END
