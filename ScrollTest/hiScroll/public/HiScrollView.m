//
//  HiScrollView.m
//  ScrollTest
//
//  Created by four on 2020/12/23.
//

#import "HiScrollView.h"
#import "HiScrollViewPrivate.h"
#import "HiScrollViewVertical.h"
#import "HiScrollViewHorizontal.h"
#import <objc/runtime.h>
#import <pthread.h>

// default 从小到大
static inline HiScrollNode * hi_nodesSort(HiScrollNode *head, BOOL revert, HiScrollViewProperty direction)
{
    HiScrollNode * first = nil;     /*排列后有序链的表头指针*/
    HiScrollNode * tail = nil;      /*排列后有序链的表尾指针*/
    HiScrollNode * p_min = nil;     /*保留键值更小的节点的前驱节点的指针*/
    HiScrollNode * min = nil;       /*存储最小节点*/
    HiScrollNode * p = nil;         /*当前比较的节点*/
    
    while (head) {
        for (p = head,min = head; p.nextNode != nil; p = p.nextNode) {
            BOOL res = false;
            
            if (revert) {
                res = [p.nextNode.object hi_propertyForDirection:direction] > [min.object hi_propertyForDirection:direction];
            } else {
                res = [p.nextNode.object hi_propertyForDirection:direction] < [min.object hi_propertyForDirection:direction];
            }
            
            if (res) {
                p_min = p;
                min = p.nextNode;
            }
        }
        
        if (!first) {
            first = min;
            tail = min;
            
        } else {
            tail.nextNode = min;
            tail = min;
        }
        
        if ([min isEqual: head]) {
            head = head.nextNode;
            
        } else  {
            p_min.nextNode = min.nextNode;
        }
    }
    
    if (first) tail.nextNode = nil;
    head = first;
    return head;
}

@implementation UIScrollView (HiScrollView)

/// MARK:- 容器调用的方法
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)recognizer {
    
    self.hi_state = recognizer.state;
    switch (recognizer.state) {
            
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            break;
            
        case UIGestureRecognizerStateBegan:
            // 移除 动画
            [self.animator removeAllBehaviors];
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            // 往上滑为负数，往下滑为正数
            CGPoint offset = [recognizer translationInView:self.superview];
            [self checkAvailable];
            UIScrollView *actionScrollView = [self controlScrollWithOffset:offset];
            if (![actionScrollView isEqual:self.actionScrollView]) {
                self.actionScrollView.hi_draggin = false;// 重置
                self.actionScrollView = actionScrollView;
            }
            self.actionScrollView.hi_draggin = true;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            [self.timer destroyTimer];
            self.actionScrollView.hi_draggin = false;
            BOOL outside = [self.actionScrollView overSizeWithDirection:self.scrollDirection];
            if (!self.available && !outside) return;

            if (outside) {
                [self resetScrollView];
                return;
            }
            self.dynamicItem.center = self.superview.bounds.origin;
            // velocity是在手势结束的时候获取的竖直方向的手势速度
            CGPoint velocity = [recognizer velocityInView:self.superview];
            [self addInertialBehaviorWithVelocity:velocity];
        }
            break;
    }
    
    // 保证每次只是移动的距离，不是从头一直移动的距离
    self.dynamicItem.center = self.superview.bounds.origin;
    [recognizer setTranslation:CGPointZero inView:self.superview];
}

- (void)checkAvailable {
    self.available = true;
    __weak typeof(self) weak = self;
    [self.timer afterInterval:0.15 synce:^{
        __strong typeof(weak) strong = weak;
        strong.available = false;
    }];
}

// 添加线性动画
- (void)addInertialBehaviorWithVelocity:(CGPoint)velocity {
    
    UIDynamicItemBehavior *inertialBehavior = nil;
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
        {
            CGFloat value = [self velocityWithValue:velocity.y];
            inertialBehavior = [self addInertialBehaviorWithVerticalVelocity:value];
            break;
        }
        case HiScrollViewDirectionHorizontal:
        {
            CGFloat value = [self velocityWithValue:velocity.x];
            inertialBehavior = [self addInertialBehaviorWithHorizontalVelocity:value];
            break;
        }
    }

    if (inertialBehavior) [self.animator addBehavior:inertialBehavior];
}

// 加速值
- (CGFloat)velocityWithValue:(CGFloat)value {
    CGFloat y = value;
    
    static CGFloat _value = 150; // 150 内不加速
    if (y < 0) y = -y;
    if (y > 0 && y < _value) value = CGFLOAT_MIN * y / value;
    
    return value;
}

/// MARK: 控制滚动
/// 控制垂直滚动的方法
/// @return 当前响应的 scroll view
- (UIScrollView *)controlScrollWithOffset:(CGPoint)offset {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            return [self controlScrollForVertical:offset.y state:UIGestureRecognizerStateChanged];
            
        case HiScrollViewDirectionHorizontal:
            return [self controlScrollForHorizontal:offset.x state:UIGestureRecognizerStateChanged];
    }
}

// 恢复
- (void)resetScrollView {
    
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            [self resetVerticalScrollView:self.actionScrollView];

            break;
        case HiScrollViewDirectionHorizontal:
            [self resetHorizontalScrollView:self.actionScrollView];
            break;
    }
}

/// MARK: - HiScrollGestureDelegate
- (void)gesture:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    id view = touch.view;
    HiScrollNode *node1 = [self generateNode];
    HiScrollNode *node2 = [self generateNode];

    while (![view isEqual:self]) {
        if ([view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scroll = view;
            if (scroll.hi_scrollEnabled) { // 可以滚动
                HiScrollNode *_node1 = [scroll generateNode];
                HiScrollNode *_node2 = [scroll generateNode];

                _node1.nextNode = node1;
                _node2.nextNode = node2;
                node1 = _node1;
                node2 = _node2;
            }
        }
        
        view = [view superview];
    }
    
    if (HiScrollViewDirectionVertical == self.scrollDirection) {
        self.topNode = hi_nodesSort(node1,true,HiScrollViewPropertyTop);
        self.bottomNode = hi_nodesSort(node2, true, HiScrollViewPropertyBottom);

    } else if (HiScrollViewDirectionHorizontal == self.scrollDirection) {
        self.leftNode = hi_nodesSort(node1,true,HiScrollViewPropertyLeft);
        self.rightNode = hi_nodesSort(node2, true, HiScrollViewPropertyRight);
    }
}

/// MARK: - public
- (void)hi_scrollWithScrollDirection:(HiScrollViewDirection)direction {
    if (![self.scrollGesture addGestureAtView:self]) self.scrollDirection = direction;
}

@end
