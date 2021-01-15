//
//  HiScrollViewPrivate.h
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import <UIKit/UIKit.h>
#import "HiScrollViewProperty.h"

typedef enum : NSUInteger {
    HiScrollViewPropertyTop,
    HiScrollViewPropertyBottom,
    HiScrollViewPropertyLeft,
    HiScrollViewPropertyRight,
} HiScrollViewProperty;

typedef struct __attribute__((objc_boxable)) HiOffsetValue {
    CGFloat value;
    BOOL bounce;
} HiOffsetValue;

UIKIT_STATIC_INLINE HiOffsetValue HiOffsetValueMake(CGFloat value, BOOL bounce) {
    HiOffsetValue offsetValue = {value, bounce};
    return offsetValue;
}

NS_ASSUME_NONNULL_BEGIN

extern CGFloat hi_rubberBandDistance(CGFloat offset, CGFloat dimension);

@interface UIScrollView (HiScrollViewPrivate)

- (NSInteger)hi_propertyForDirection:(HiScrollViewProperty)direction;

/// 更新 direction 上的值
- (void)updateContentOffset:(CGFloat)offset direction:(HiScrollViewDirection)direction;

- (UIAttachmentBehavior *)attachmentBehaviorWithTarget:(CGPoint)target action:(void (^)(void))action;

- (HiScrollNode *)generateNode;

/// 内容不足
- (BOOL)contentInSizeWithDirection:(HiScrollViewDirection)direction;

/// 滚到边界
- (BOOL)scrollBoundsWithDirction:(HiScrollViewDirection)scrollDirection;

/// 超出边界
- (BOOL)overSizeWithDirection:(HiScrollViewDirection)scrollDirection;

/// 弹性动画 外部容器调用
/// @param scrollView 要添加的 scroll
- (void)springBehaviorWithTarget:(CGPoint)target scrollView:(UIScrollView *)scrollView;

/// 控制滚动 外部容器调用
- (void)controlScrollOffset:(CGFloat)offset state:(UIGestureRecognizerState)state;

/// 添加线性加速 外部容器调用
- (UIDynamicItemBehavior *)addInertialBehaviorWithVelocity:(CGPoint)velocity;

/// scroll 超出内容区 重置 外部容器调用
- (void)resetScrollView;

@end

NS_ASSUME_NONNULL_END
