//
//  HiScrollViewVertical.m
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import "HiScrollViewVertical.h"
#import "HiScrollViewPrivate.h"
#import "HiScrollViewPublic.h"

@implementation UIScrollView (HiScrollViewVertical)

/// MARK: 控制上下滚动的方法
- (void)controlScrollForVertical:(CGFloat)offset state:(UIGestureRecognizerState)state{
    
    self.actionScrollView = [self changeVerticalOffset:offset];
    if (UIGestureRecognizerStateEnded == state) [self resetVerticalScrollView:self.actionScrollView];
}

/// MARK: 改变 offset
- (UIScrollView *)changeVerticalOffset:(CGFloat)offset {
    // 上 : offset < 0
    CGFloat size = self.frame.size.height;
    UIScrollView *actionScrollView = self.actionScrollView;
    if (self.actionScrollView.overVerticalSize) { // 当前处理滚动的 scroll view 没有回到原来的位置 优先 actionScrollView 响应
        [self.actionScrollView canChangeVerticalOffset:offset size:size];
    } else {
        actionScrollView = [self verticalActionScrollViewWithOffset:offset size:size];;
    }
    
    return actionScrollView;
}

/// MARK: 是否可以处理 滚动, 如果可以 处理
- (BOOL)canChangeVerticalOffset:(CGFloat)offset size:(CGFloat)size {
    if (!self.hi_scrollEnabled) return false;
    
    CGFloat target = self.contentOffset.y - offset;
    BOOL res = true;
    if (target < self.minVerticalTop) {
        if (self.bouncesInsets.top) {
            target = self.contentOffset.y - [self springWithVerticalOffset:hi_rubberBandDistance(offset, size)];
        } else {
            target = self.minVerticalTop;
            res = false;
        }
        
    } else {
        CGFloat maxOffsetSize = self.maxVerticalOffset;
        if (target > maxOffsetSize) {
            if (self.bouncesInsets.bottom) {
                target = self.contentOffset.y - [self springWithVerticalOffset:hi_rubberBandDistance(offset, size)];
            } else {
                target = maxOffsetSize;
                res = false;
            }
        }
    }

    [self updateContentOffset:CGPointMake(0, target)];
    
    return res;
}

/// MARK: 可以响应事件的 scroll view
- (UIScrollView *)verticalActionScrollViewWithOffset:(CGFloat)offset size:(CGFloat)size {
    // 上
    if (offset < 0) return [self verticalActionScrollViewWithNode:self.topNode offset:offset size:size];

    return [self verticalActionScrollViewWithNode:self.bottomNode offset:offset size:size];
}

- (UIScrollView *)verticalActionScrollViewWithNode:(HiScrollNode *)scrollNode offset:(CGFloat)offset size:(CGFloat)size{
    
    HiScrollNode *node = scrollNode;
    while (node && ![node.object canChangeVerticalOffset:offset size:size]) {
        node = node.nextNode;
    }
    return node.object;
}

/// MARK: if oversize, resetsize
- (void)resetVerticalScrollView:(UIScrollView *)scrollView {
    if (scrollView.overVerticalSize) {
        
        CGFloat y = scrollView.minVerticalTop;
        
        if (scrollView.overVerticalBounds > 0) {
            y = [scrollView contentInSizeWithDirection:self.scrollDirection] ? scrollView.minVerticalTop : scrollView.maxVerticalOffset;
        }
        
        [self springBehaviorWithTarget:CGPointMake(0, y) scrollView:scrollView];
    }
}

/// MARK: 添加线性加速 ,没有超过size
- (UIDynamicItemBehavior *)addInertialBehaviorWithVerticalVelocity:(CGFloat)velocity {
    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
    
    [inertialBehavior addLinearVelocity:CGPointMake(0, velocity) forItem:self.dynamicItem];
    inertialBehavior.resistance = 2.3;
    __block CGPoint lastCenter = CGPointZero;
    __weak typeof(self) weak = self;
    inertialBehavior.action = ^{
        __strong typeof(weak) strong = weak;
        // 得到每次移动的距离
        CGFloat current = strong.dynamicItem.center.y - lastCenter.y;
        // 更新 actionScrollView
        [strong controlScrollForVertical:current state:UIGestureRecognizerStateEnded];
        lastCenter = strong.dynamicItem.center;
    };
    return inertialBehavior;
}

@end
