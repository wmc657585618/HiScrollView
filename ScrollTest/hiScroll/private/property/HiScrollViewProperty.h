//
//  HiScrollViewProperty.h
//  ScrollTest
//
//  Created by four on 2021/1/15.
//

#import <UIKit/UIKit.h>
#import "HiScrollObject.h"
#import "HiScrollViewDefine.h"
#import "HiScrollViewPublic.h"
#import "HiScrollViewPropertyHorizontal.h"
#import "HiScrollViewPropertyVertical.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HiScrollViewProperty)<HiScrollGestureDelegate>

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

@property (nonatomic, assign, readonly) BOOL scrollDirectTop;// 可以向上滚动
@property (nonatomic, assign, readonly) BOOL scrollDirectBottom;
@property (nonatomic, assign, readonly) BOOL scrollDirectLeft;
@property (nonatomic, assign, readonly) BOOL scrollDirectRight;

@property (nonatomic, strong) HiScrollNode *topNode;
@property (nonatomic, strong) HiScrollNode *bottomNode;
@property (nonatomic, strong) HiScrollNode *leftNode;
@property (nonatomic, strong) HiScrollNode *rightNode;
@property (nonatomic, assign) HiScrollViewDirection scrollDirection;
@property (nonatomic, assign) BOOL hi_draggin;

@end

NS_ASSUME_NONNULL_END
