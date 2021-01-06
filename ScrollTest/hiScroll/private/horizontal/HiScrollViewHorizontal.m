//
//  HiScrollViewHorizontal.m
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import "HiScrollViewHorizontal.h"
#import "HiScrollViewPrivate.h"
#import "HiScrollViewPublic.h"

@implementation UIScrollView (HiScrollViewHorizontal)

/// MARK: 控制上下滚动的方法
- (void)controlScrollForHorizontal:(CGFloat)offset state:(UIGestureRecognizerState)state{
    
    self.actionScrollView = [self changeHorizontalOffset:offset];
    if (UIGestureRecognizerStateEnded == state) [self resetHorizontalScrollView:self.actionScrollView];
}

/// MARK: 改变 offset
- (UIScrollView *)changeHorizontalOffset:(CGFloat)offset {
    // 左 : offset < 0
    CGFloat size = self.frame.size.width;
    UIScrollView *actionScrollView = self.actionScrollView;
    if (self.actionScrollView.overHorizontalSize) { // 当前处理滚动的 scroll view 没有回到原来的位置 优先 actionScrollView 响应
        [self.actionScrollView canChangeHorizontalOffset:offset size:size];
    } else {
        actionScrollView = [self horizontalActionScrollViewWithOffset:offset size:size];;
    }
    
    return actionScrollView;
}

/// MARK: 是否可以处理 滚动
- (BOOL)canChangeHorizontalOffset:(CGFloat)offset size:(CGFloat)size {
    if (!self.hi_scrollEnabled) return false;
    
    CGFloat target = self.contentOffset.x - offset;
    BOOL res = true;
    if (target < self.minHorizontalLeft) {
        if (self.bouncesInsets.left) {
            target = self.contentOffset.x - [self springWithHorizontalOffset:hi_rubberBandDistance(offset, size)];
        } else {
            target = self.minHorizontalLeft;
            res = false;
        }
        
    } else {
        CGFloat maxOffsetSize = self.maxHorizontalOffset;
        if (target > maxOffsetSize) {
            if (self.bouncesInsets.right) {
                target = self.contentOffset.x - [self springWithHorizontalOffset:hi_rubberBandDistance(offset, size)];
            } else {
                target = maxOffsetSize;
                res = false;
            }
        }
    }

    [self updateContentOffset:CGPointMake(target, 0)];
    
    return res;
}

/// MARK: 可以响应事件的 scroll view
- (UIScrollView *)horizontalActionScrollViewWithOffset:(CGFloat)offset size:(CGFloat)size {
    // left : offset < 0
    if (offset < 0) return [self horizonalActionScrollViewWithNode:self.leftNode offset:offset size:size];

    return [self horizonalActionScrollViewWithNode:self.rightNode offset:offset size:size];
}

- (UIScrollView *)horizonalActionScrollViewWithNode:(HiScrollNode *)scrollNode offset:(CGFloat)offset size:(CGFloat)size{
    
    HiScrollNode *node = scrollNode;
    while (node && ![node.object canChangeHorizontalOffset:offset size:size]) {
        node = node.nextNode;
    }
    return node.object;
}

/// MARK: if oversize, resetsize
- (void)resetHorizontalScrollView:(UIScrollView *)scrollView {
    if (scrollView.overHorizontalSize) {
        
        CGFloat x = scrollView.minHorizontalLeft;
        if (scrollView.overHorizontalBounds > 0) {
            x = scrollView.contentInSize ? scrollView.minHorizontalLeft : scrollView.maxHorizontalRight;
        }
        [self springBehaviorWithTarget:CGPointMake(x, 0) scrollView:scrollView];
    }
}

/// MARK: 添加线性加速 ,没有超过size
- (UIDynamicItemBehavior *)addInertialBehaviorWithHorizontalVelocity:(CGFloat)velocity {
    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
    
    [inertialBehavior addLinearVelocity:CGPointMake(velocity, 0) forItem:self.dynamicItem];
    inertialBehavior.resistance = 2.3;
    __block CGPoint lastCenter = CGPointZero;
    __weak typeof(self) weak = self;
    inertialBehavior.action = ^{
        __strong typeof(weak) strong = weak;
        // 得到每次移动的距离
        CGFloat current = strong.dynamicItem.center.x - lastCenter.x;
        // 更新 actionScrollView
        [strong controlScrollForHorizontal:current state:UIGestureRecognizerStateEnded];
        lastCenter = strong.dynamicItem.center;
    };
    return inertialBehavior;
}

@end
