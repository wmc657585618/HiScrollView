//
//  HiScrollView.m
//  ScrollTest
//
//  Created by four on 2020/12/23.
//

#import "HiScrollView.h"
#import "HiScrollViewPrivate.h"
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

- (void)changeNode:(HiScrollNode *)scrollNode draggin:(BOOL)draggin{
    
    HiScrollNode *node = scrollNode;
    while (node) {
        node.object.hi_draggin = draggin;
        node = node.nextNode;
    }
}


- (void)changeDraggin {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            [self changeNode:self.topNode draggin:true];
            break;
        case HiScrollViewDirectionHorizontal:
            [self changeNode:self.leftNode draggin:true];
            break;
    }
}

- (void)resetDraggin {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            [self changeNode:self.topNode draggin:false];
            break;
        case HiScrollViewDirectionHorizontal:
            [self changeNode:self.leftNode draggin:false];
            break;
    }
}

// 加速值
- (CGFloat)velocityWithValue:(CGFloat)value {
    CGFloat y = value;
    
    static CGFloat _value = 150; // 150 内不加速
    if (y < 0) y = -y;
    if (y > 0 && y < _value) value = CGFLOAT_MIN * y / value;
    
    return value;
}

/// 手势
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            break;
            
        case UIGestureRecognizerStateBegan:
        {
            [self changeDraggin];
            // 移除 动画
            [self.animator removeAllBehaviors];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            // 往上滑为负数，往下滑为正数
            CGPoint offset = [recognizer translationInView:self.superview];
            CGFloat value = HiScrollViewDirectionVertical == self.scrollDirection ? offset.y : offset.x;
            [self checkAvailable];
            [self controlScrollOffset:value state:UIGestureRecognizerStateChanged];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            [self.timer destroyTimer];
            [self resetDraggin];
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
            UIDynamicItemBehavior *inertialBehavior = [self addInertialBehaviorWithVelocity:velocity];
            if (inertialBehavior) [self.animator addBehavior:inertialBehavior];
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

/// MARK: - HiScrollGestureDelegate
- (BOOL)gesture:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *view = touch.view;
    HiScrollNode *node1 = [self generateNode];
    HiScrollNode *node2 = [self generateNode];

    while (![view isEqual:self]) {        
        if ([view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scroll = (UIScrollView *)view;
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
    
    return true;
}

- (BOOL)_isDragging {
    if (self.hi_scrollEnabled) return self.hi_draggin;
    return [self _isDragging];
}

+ (void)load {
    SEL originalSelector = @selector(isDragging);
    SEL altSelector = @selector(_isDragging);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method altMetthod = class_getInstanceMethod(self, altSelector);
    
    if (originalMethod && altMetthod) {
        method_exchangeImplementations(originalMethod, altMetthod);
    }
}

/// MARK: - public
- (void)hi_scrollWithScrollDirection:(HiScrollViewDirection)direction {
    if (![self.scrollGesture addGestureAtView:self]) self.scrollDirection = direction;
}

@end
