//
//  HiScrollViewHorizontal.h
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HiScrollViewHorizontal)

/// 控制滚动的方法
/// @return 当前响应的 scroll view
- (UIScrollView *)controlScrollForHorizontal:(CGFloat)offset state:(UIGestureRecognizerState)state;
- (UIDynamicItemBehavior *)addInertialBehaviorWithHorizontalVelocity:(CGFloat)velocity;
- (void)resetHorizontalScrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
