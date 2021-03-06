//
//  HiScrollViewPrivate.m
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import "HiScrollViewPrivate.h"
#import <objc/runtime.h>

typedef struct __attribute__((objc_boxable)) HiScrollOffset {
    BOOL changed; // 是否改
    CGFloat target;
    BOOL available;
} HiScrollOffset;

UIKIT_STATIC_INLINE HiScrollOffset HiScrollOffsetMake(BOOL changed, CGFloat target, BOOL available) {
    HiScrollOffset offset = {changed, target,available};
    return offset;
}

// 来自网络
/*
 f(x, d, c) = (x * d * c) / (d + c * x)

 where,
 x – distance from the edge
 c – constant (UIScrollView uses 0.55)
 d – dimension, either width or height
 */
inline CGFloat hi_rubberBandDistance(CGFloat offset, CGFloat dimension) {
    
    static CGFloat const constant = 0.55f;
    CGFloat b = dimension + constant * fabs(offset);
    if (0 == b) return 0;
    CGFloat result = (constant * fabs(offset) * dimension) / b;
    return offset < 0.0f ? -result : result;
}

@implementation UIScrollView (HiScrollViewPrivate)

/// MARK: - method
- (BOOL)contentInSizeWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.maxVerticalBottom < self.frame.size.height;

        case HiScrollViewDirectionHorizontal:
            return self.maxHorizontalRight < self.frame.size.width;
    }
}

- (BOOL)scrollBoundsWithDirction:(HiScrollViewDirection)scrollDirection {
    switch (scrollDirection) {
        case HiScrollViewDirectionVertical:
            return self.scrollTop || self.scrollBottom;

        case HiScrollViewDirectionHorizontal:
            return self.scrollLeft || self.scrollRight;
    }
}

- (BOOL)overSizeWithDirection:(HiScrollViewDirection)scrollDirection {
    switch (scrollDirection) {
        case HiScrollViewDirectionVertical:
            return self.overVerticalSize;

        case HiScrollViewDirectionHorizontal:
            return self.overHorizontalSize;
    }
}

- (CGFloat)overBoundsWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.overVerticalBounds;
        case HiScrollViewDirectionHorizontal:
            return self.overHorizontalBounds;
    }
}

- (NSInteger)hi_propertyForDirection:(HiScrollViewProperty)direction {
    
    switch (direction) {
        case HiScrollViewPropertyTop:
            return self.topProperty;
            
        case HiScrollViewPropertyBottom:
            return self.bottomProperty;

        case HiScrollViewPropertyLeft:
            return self.leftProperty;
            
        case HiScrollViewPropertyRight:
            return self.rightProperty;
    }
}

- (void)updateContentOffset:(CGFloat)offset direction:(HiScrollViewDirection)direction{
    if (self.hi_scrollEnabled) {
        CGPoint point = self.contentOffset;
        switch (direction) {
            case HiScrollViewDirectionVertical:
                point.y = offset;
                break;
            case HiScrollViewDirectionHorizontal:
                point.x = offset;
                break;
        }
        self.contentOffset = point;
    }
}

- (UIAttachmentBehavior *)attachmentBehaviorWithTarget:(CGPoint)target action:(void (^)(void))action {
    UIAttachmentBehavior *springBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicItem attachedToAnchor:target];
    springBehavior.length = 0;
    springBehavior.damping = 1;
    springBehavior.frequency = CGFLOAT_MIN;
    springBehavior.action = action;
    return springBehavior;
}

- (HiScrollNode *)generateNode {
    HiScrollNode *node = [[HiScrollNode alloc] init];
    node.object = self;
    return node;
}

- (void)springBehaviorWithTarget:(CGPoint)target scrollView:(UIScrollView *)scrollView {
    
    self.dynamicItem.center = scrollView.contentOffset;
            
    [self.animator removeAllBehaviors];
    __weak typeof(self) weak = self;
    __weak typeof(self) weakScroll = scrollView;
    UIAttachmentBehavior *springBehavior = [self attachmentBehaviorWithTarget:target action:^{
        __strong typeof(weak) strong = weak;
        __strong typeof(weakScroll) strongScroll = weakScroll;
        strongScroll.contentOffset = strong.dynamicItem.center;
        if ([strongScroll scrollBoundsWithDirction:strong.scrollDirection]) [strong.animator removeAllBehaviors];
    }];
    
    [self.animator addBehavior:springBehavior];
}

- (CGFloat)sizeForDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.frame.size.height;
        case HiScrollViewDirectionHorizontal:
            return self.frame.size.width;
    }
}

- (CGFloat)targetForDirection:(HiScrollViewDirection)direction offset:(CGFloat)offset{
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.contentOffset.y - offset;
        case HiScrollViewDirectionHorizontal:
            return self.contentOffset.x - offset;
    }
}

///MARK:- 最大偏移量
- (CGFloat)maxOffsetWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.maxVerticalOffset;
        case HiScrollViewDirectionHorizontal:
            return self.maxHorizontalOffset;
    }
}

///MARK:- 最小偏移量
- (CGFloat)minOffsetWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.minVerticalTop;
        case HiScrollViewDirectionHorizontal:
            return self.minHorizontalLeft;
    }
}

///MARK:- 达到最小偏移量是否可以触发bounce
- (BOOL)minBounceWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.bouncesInsets.top;
        case HiScrollViewDirectionHorizontal:
            return self.bouncesInsets.left;
    }
}

///MARK:- 达到最大偏移量是否可以触发bounce
- (BOOL)maxBounceWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.bouncesInsets.bottom;
        case HiScrollViewDirectionHorizontal:
            return self.bouncesInsets.right;
    }
}

- (HiScrollOffset)changeMinTarget:(CGFloat)target direction:(HiScrollViewDirection)direction size:(CGSize)size {
    CGFloat min = [self minOffsetWithDirection:direction];
    BOOL changed = true; // 是否可以处理 滚动
    BOOL available = false;
    if (target < min) {
        available = true;
        if ([self minBounceWithDirection:direction]) {
            target = [self targetForDirection:direction offset:hi_rubberBandDistance(size.width, size.height)];
        } else {
            target = min;
            changed = false;
        }
    }
    
    return HiScrollOffsetMake(changed, target, available);
}

- (HiScrollOffset)changeMaxTarget:(CGFloat)target direction:(HiScrollViewDirection)direction size:(CGSize)size {
    CGFloat maxOffsetSize = [self maxOffsetWithDirection:direction];
    BOOL changed = true; // 是否可以处理 滚动
    BOOL available = false;
    if (target > maxOffsetSize) {
        available = true;
        if ([self maxBounceWithDirection:direction]) {
            target = [self targetForDirection:direction offset:hi_rubberBandDistance(size.width, size.height)];
        } else {
            target = maxOffsetSize;
            changed = false;
        }
    }
    return HiScrollOffsetMake(changed, target, available);
}

- (CGPoint)resetPointForDirection:(HiScrollViewDirection)direction {
    CGFloat value = [self minOffsetWithDirection:direction];
    
    if ([self overBoundsWithDirection:direction] > 0 && ![self contentInSizeWithDirection:direction]) {
        value =  [self maxOffsetWithDirection:direction];
    }
    
    return HiScrollViewDirectionVertical == direction ? CGPointMake(0, value) : CGPointMake(value, 0);
}

- (HiScrollNode *)minNode {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            return self.topNode;
        case HiScrollViewDirectionHorizontal:
            return self.leftNode;
    }
}

- (HiScrollNode *)maxNode {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            return self.bottomNode;
        case HiScrollViewDirectionHorizontal:
            return self.rightNode;
    }
}

/// MARK: - 容器调用
/// MARK: 控制上下滚动的方法
- (void)controlScrollOffset:(CGFloat)offset state:(UIGestureRecognizerState)state {
    
    if (UIGestureRecognizerStateEnded == state) {
        [self endChangeOffset:offset];
        
    } else if (UIGestureRecognizerStateChanged == state) {
        self.actionScrollView = [self changeOffset:offset];
    }
}

/// MARK: - 改变 offset (滑动中)
- (UIScrollView *)changeOffset:(CGFloat)offset {
    // 上 : offset < 0
    UIScrollView *actionScrollView = self.actionScrollView;
    if ([self.actionScrollView overSizeWithDirection:self.scrollDirection]) { // 当前处理滚动的 scroll view 没有回到原来的位置 优先 actionScrollView 响应
        [self.actionScrollView canChangeOffset:offset direction:self.scrollDirection];
    } else {
        actionScrollView = [self actionScrollViewWithOffset:offset];;
    }
    
    return actionScrollView;
}

/// MARK: 可以响应事件的 scroll view
- (UIScrollView *)actionScrollViewWithOffset:(CGFloat)offset {
    HiScrollNode *node = offset < 0 ? [self minNode] : [self maxNode];
    while (node && ![node.object canChangeOffset:offset direction:self.scrollDirection]) {
        node = node.nextNode;
    }
    return node.object;
}

/// MARK: 是否可以处理 滚动, 如果可以 处理
- (BOOL)canChangeOffset:(CGFloat)offset direction:(HiScrollViewDirection)direction {
    if (!self.hi_scrollEnabled) return false;

    CGFloat target = [self targetForDirection:direction offset:offset];
    CGSize offsetSize = CGSizeMake(offset, [self sizeForDirection:direction]);
    HiScrollOffset objc = [self changeMinTarget:target direction:direction size:offsetSize];

    if (!objc.available) objc = [self changeMaxTarget:target direction:direction size:offsetSize];

    [self updateContentOffset:objc.target direction:direction];
    
    return objc.changed;
}

/// MARK: 改变 offset (滑动中)

/// MARK: - 改变 offset (滑动结束)
- (UIScrollView *)endChangeOffset:(CGFloat)offset {
    UIScrollView *actionScrollView = [self endActionScrollViewWithOffset:offset];;
    return actionScrollView;
}

- (UIScrollView *)endActionScrollViewWithOffset:(CGFloat)offset {
    HiScrollNode *node = offset < 0 ? [self minNode] : [self maxNode];
    while (node && ![node.object canChangeEndOffset:offset direction:self.scrollDirection]) {
        node = node.nextNode;
    }
    return node.object;
}

/// MARK: 是否可以处理 滚动, 如果可以 处理
- (BOOL)canChangeEndOffset:(CGFloat)offset direction:(HiScrollViewDirection)direction {
    if (!self.hi_scrollEnabled) return false;

    CGFloat target = [self targetForDirection:direction offset:offset];
    CGSize offsetSize = CGSizeMake(offset, [self sizeForDirection:direction]);
    HiScrollOffset objc = [self changeEndMinTarget:target direction:direction size:offsetSize];

    if (!objc.available) objc = [self changeEndMaxTarget:target direction:direction size:offsetSize];

    [self updateContentOffset:objc.target direction:direction];

    return objc.changed;
}

- (HiScrollOffset)changeEndMinTarget:(CGFloat)target direction:(HiScrollViewDirection)direction size:(CGSize)size {
    CGFloat min = [self minOffsetWithDirection:direction];
    BOOL available = false;
    BOOL changed = true;
    if (target < min) {
        available = true;
        target = min;
        changed = false;
    }
    return HiScrollOffsetMake(changed, target, available);
}

- (HiScrollOffset)changeEndMaxTarget:(CGFloat)target direction:(HiScrollViewDirection)direction size:(CGSize)size {
    CGFloat maxOffsetSize = [self maxOffsetWithDirection:direction];
    BOOL available = false;
    BOOL changed = true;

    if (target > maxOffsetSize) {
        available = true;
        target = maxOffsetSize;
        changed = false;
    }
    return HiScrollOffsetMake(changed, target, available);
}

/// MARK: 添加线性加速
- (UIDynamicItemBehavior *)addInertialBehaviorWithVelocity:(CGPoint)velocity {
    if (!self.actionScrollView)return nil;
    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
    
    [inertialBehavior addLinearVelocity:velocity forItem:self.dynamicItem];
    inertialBehavior.resistance = 2.3;
    __block CGPoint lastCenter = CGPointZero;
    __weak typeof(self) weak = self;
    inertialBehavior.action = ^{
        __strong typeof(weak) strong = weak;
        // 得到每次移动的距离
        CGFloat current = 0;
        if (HiScrollViewDirectionVertical == strong.scrollDirection) {
            current = strong.dynamicItem.center.y - lastCenter.y;
        } else {
            current = strong.dynamicItem.center.x - lastCenter.x;
        }
        
        // 更新 actionScrollView
        if (strong.actionScrollView) {
            [strong controlScrollOffset:current state:UIGestureRecognizerStateEnded];
            lastCenter = strong.dynamicItem.center;
            
        } else {
            [strong.animator removeAllBehaviors];
        }
    };
    return inertialBehavior;
}

/// MARK: 改变 offset (滑动结束)


/// MARK: if oversize, resetsize
- (void)resetScrollView {
    UIScrollView *scrollView = self.actionScrollView;
    HiScrollViewDirection direction = self.scrollDirection;
    if ([scrollView overSizeWithDirection:direction]) {
        CGPoint target = [scrollView resetPointForDirection:direction];
        [self springBehaviorWithTarget:target scrollView:scrollView];
    }
}



@end
