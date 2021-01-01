//
//  HiScrollViewPrivate.h
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import <UIKit/UIKit.h>
#import "HiScrollObject.h"
#import "HiScrollViewPropertyHorizontal.h"
#import "HiScrollViewPropertyVertical.h"
#import "HiScrollViewDefine.h"

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

@interface UIScrollView (HiScrollViewPrivate)<HiScrollGestureDelegate>

//弹性和惯性动画
@property (nonatomic, strong, readonly) UIDynamicAnimator *animator; // 物理仿真器
@property (nonatomic, strong, readonly) HiDynamicItem *dynamicItem;

@property (nonatomic, strong, readonly) HiScrollTimer *timer;
@property (nonatomic, assign) BOOL available; // 短时间内不滑动 false

@property (nonatomic, strong, readonly) HiScrollWeak *actionScrollViewWeak;
@property (nonatomic, strong, readonly) HiScrollGesture *scrollGesture;

@property (nonatomic, weak) UIScrollView *actionScrollView; // 本次处理滚动的 scrollview

@property (nonatomic, assign, readonly) BOOL scrollTop;// 滚到 top
@property (nonatomic, assign, readonly) BOOL scrollBottom;
@property (nonatomic, assign, readonly) BOOL scrollLeft;
@property (nonatomic, assign, readonly) BOOL scrollRight;

@property (nonatomic, assign, readonly) BOOL contentInSize;// 内容不足

@property (nonatomic, assign) UIGestureRecognizerState hi_state;

@property (nonatomic, assign, readonly) BOOL scrollDirectTop;// 可以向上滚动
@property (nonatomic, assign, readonly) BOOL scrollDirectBottom;
@property (nonatomic, assign, readonly) BOOL scrollDirectLeft;
@property (nonatomic, assign, readonly) BOOL scrollDirectRight;

@property (nonatomic, strong) HiScrollNode *topNode;
@property (nonatomic, strong) HiScrollNode *bottomNode;
@property (nonatomic, strong) HiScrollNode *leftNode;
@property (nonatomic, strong) HiScrollNode *rightNode;
@property (nonatomic, assign) HiScrollViewDirection scrollDirection;

- (NSInteger)hi_propertyForDirection:(HiScrollViewProperty)direction;

- (void)updateContentOffset:(CGPoint)contentOffset;

- (CGFloat)springWithVerticalOffset:(CGFloat)offset;
- (CGFloat)springWithHorizontalOffset:(CGFloat)offset;
- (UIAttachmentBehavior *)attachmentBehaviorWithTarget:(CGPoint)target action:(void (^)(void))action;

- (HiScrollNode *)generateNode;
@property (nonatomic, assign) BOOL hi_draggin;

// 弹性动画
- (void)springBehaviorWithTarget:(CGPoint)target scrollView:(UIScrollView *)scrollView;
// 滚到边界
- (BOOL)scrollBoundsWithDirction:(HiScrollViewDirection)scrollDirection;
// 超出边界
- (BOOL)overSizeWithDirection:(HiScrollViewDirection)scrollDirection;
@end

NS_ASSUME_NONNULL_END
