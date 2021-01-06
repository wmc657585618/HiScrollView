//
//  HiScrollViewPrivate.m
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import "HiScrollViewPrivate.h"
#import "HiScrollViewPublic.h"
#import <objc/runtime.h>

// 来自网络
inline CGFloat hi_rubberBandDistance(CGFloat offset, CGFloat dimension) {
    
    static CGFloat const constant = 0.55f;
    CGFloat result = (constant * fabs(offset) * dimension) / (dimension + constant * fabs(offset));
    return offset < 0.0f ? -result : result;
}

@implementation UIScrollView (HiScrollViewPrivate)

/// MARK: - properties
- (UIDynamicAnimator *)animator {
    SEL key = @selector(animator);
    UIDynamicAnimator *value = objc_getAssociatedObject(self, key);
    if (!value) {
        value = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
        objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
}

- (HiDynamicItem *)dynamicItem {
    SEL key = @selector(dynamicItem);
    HiDynamicItem *value = objc_getAssociatedObject(self, key);
    if (!value) {
        value = [[HiDynamicItem alloc] init];
        objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
}

- (HiScrollTimer *)timer {
    SEL key = @selector(timer);
    HiScrollTimer *value = objc_getAssociatedObject(self, key);
    if (!value) {
        value = [[HiScrollTimer alloc] init];
        objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
}

- (void)setAvailable:(BOOL)available {
    SEL key = @selector(available);
    NSNumber *value = [NSNumber numberWithBool:available];
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)available {
    SEL key = @selector(available);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value boolValue];
}

- (HiScrollWeak *)actionScrollViewWeak {
    SEL key = @selector(actionScrollViewWeak);
    HiScrollWeak *value = objc_getAssociatedObject(self, key);
    if (!value) {
        value = [[HiScrollWeak alloc] init];
        objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
}

- (HiScrollGesture *)scrollGesture {
    
    SEL key = @selector(scrollGesture);
    HiScrollGesture *value = objc_getAssociatedObject(self, key);
    if (!value) {
        value = [[HiScrollGesture alloc] init];
        value.delegate = self;
        objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
}

- (void)setActionScrollView:(UIScrollView *)actionScrollView {
    self.actionScrollViewWeak.objc = actionScrollView;
}

- (UIScrollView *)actionScrollView {
    return self.actionScrollViewWeak.objc;
}

- (BOOL)scrollTop {
    return self.contentOffset.y == self.minVerticalTop;
}

- (BOOL)scrollBottom {
    return self.contentOffset.y == self.maxVerticalBottom - self.frame.size.height;
}

- (BOOL)scrollLeft {
    return self.contentOffset.x == self.minHorizontalLeft;
}

- (BOOL)scrollRight {
    return self.contentOffset.x == self.maxHorizontalRight - self.frame.size.width;
}

- (void)setHi_state:(UIGestureRecognizerState)hi_state {
    SEL key = @selector(hi_state);
    objc_setAssociatedObject(self, key, [NSNumber numberWithInteger:hi_state], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIGestureRecognizerState)hi_state {
    SEL key = @selector(hi_state);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value integerValue];
}

- (BOOL)scrollDirectTop {
    if (self.hi_scrollEnabled) {
        if (self.contentOffset.y > self.minVerticalTop) return true; // 未到top
        if (self.bouncesInsets.top) return true;
    }
    return false;
}

- (BOOL)scrollDirectLeft {
    if (self.hi_scrollEnabled) {
        if (self.contentOffset.x > self.minHorizontalLeft) return true;
        if (self.bouncesInsets.left) return true;
    }
    return false;
}

- (BOOL)scrollDirectBottom {
    if (self.hi_scrollEnabled) {
        if (self.contentOffset.y < self.maxVerticalBottom) return true;
        if (self.bouncesInsets.bottom) return true;
    }
    return false;
}

- (BOOL)scrollDirectRight {
    if (self.hi_scrollEnabled) {
        if (self.contentOffset.x < self.minHorizontalLeft) return true;
        if (self.bouncesInsets.right) return true;
    }
    return false;
}

- (HiScrollNode *)nodeForKey:(SEL)key {
    return objc_getAssociatedObject(self, key);
}

- (void)setNodeForKey:(SEL)key value:(HiScrollNode *)value{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HiScrollNode *)topNode {
    return [self nodeForKey:@selector(topNode)];
}

- (void)setTopNode:(HiScrollNode *)topNode {
    [self setNodeForKey:@selector(topNode) value:topNode];
}

- (HiScrollNode *)bottomNode {
    return [self nodeForKey:@selector(bottomNode)];
}

- (void)setBottomNode:(HiScrollNode *)bottomNode {
    [self setNodeForKey:@selector(bottomNode) value:bottomNode];
}

- (HiScrollNode *)leftNode {
    return [self nodeForKey:@selector(leftNode)];
}

- (void)setLeftNode:(HiScrollNode *)leftNode {
    [self setNodeForKey:@selector(leftNode) value:leftNode];
}

- (HiScrollNode *)rightNode {
    return [self nodeForKey:@selector(rightNode)];
}

- (void)setRightNode:(HiScrollNode *)rightNode {
    [self setNodeForKey:@selector(rightNode) value:rightNode];
}

- (void)setScrollDirection:(HiScrollViewDirection)scrollDirection {
    SEL key = @selector(scrollDirection);
    objc_setAssociatedObject(self, key, @(scrollDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HiScrollViewDirection)scrollDirection {
    SEL key = @selector(scrollDirection);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value integerValue];
}

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

- (void)updateContentOffset:(CGPoint)contentOffset {
    if (self.hi_scrollEnabled) self.contentOffset = contentOffset;
}

// 弹簧系数
- (CGFloat)springWithOffset:(CGFloat)offset size:(CGFloat)size{
    
    static CGFloat margin = 300.0;
    static CGFloat value = 7.0;
    
    CGFloat s = size;
    if (s < 0) { // 上面超出
        s = -s;
    }
    
    if (s > 0) {
        if (s > margin) return s / value;
        s = s * value / margin;
        if (s > 1) return offset / s;
    }
    return offset;
}

- (CGFloat)springWithVerticalOffset:(CGFloat)offset {
    return [self springWithOffset:offset size:self.overVerticalBounds];
}

- (CGFloat)springWithHorizontalOffset:(CGFloat)offset {
    return [self springWithOffset:offset size:self.overHorizontalBounds];
}

- (UIAttachmentBehavior *)attachmentBehaviorWithTarget:(CGPoint)target action:(void (^)(void))action {
    UIAttachmentBehavior *springBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicItem attachedToAnchor:target];
    springBehavior.length = 0;
    springBehavior.damping = 1;
    springBehavior.frequency = 2;
    springBehavior.action = action;
    return springBehavior;
}

- (HiScrollNode *)generateNode {
    HiScrollNode *node = [[HiScrollNode alloc] init];
    node.object = self;
    return node;
}

- (void)setHi_draggin:(BOOL)hi_draggin {
    SEL key = @selector(hi_draggin);
    objc_setAssociatedObject(self, key, @(hi_draggin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hi_draggin {
    SEL key = @selector(hi_draggin);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value boolValue];
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

- (BOOL)_isDragging {
    if (self.hi_scrollEnabled) return self.hi_draggin;
    return [self _isDragging];
}

+ (void)load {
    SEL originalSelector = @selector(isDragging);
    SEL altSelector = @selector(_isDragging);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method altMetthod = class_getInstanceMethod(self, altSelector);
    
    if (originalMethod && altMetthod)
    {
        method_exchangeImplementations(originalMethod, altMetthod);
    }
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

- (CGFloat)maxOffsetWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.maxVerticalOffset;
        case HiScrollViewDirectionHorizontal:
            return self.maxHorizontalOffset;
    }
}

- (CGFloat)minOffsetWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.minVerticalTop;
        case HiScrollViewDirectionHorizontal:
            return self.minHorizontalLeft;
    }
}

- (BOOL)minBounceWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.bouncesInsets.top;
        case HiScrollViewDirectionHorizontal:
            return self.bouncesInsets.left;
    }
}

- (BOOL)maxBounceWithDirection:(HiScrollViewDirection)direction {
    switch (direction) {
        case HiScrollViewDirectionVertical:
            return self.bouncesInsets.bottom;
        case HiScrollViewDirectionHorizontal:
            return self.bouncesInsets.right;
    }
}


/// MARK: 是否可以处理 滚动, 如果可以 处理
- (BOOL)canChangeOffset:(CGFloat)offset size:(CGFloat)size direction:(HiScrollViewDirection)directon {
    if (!self.hi_scrollEnabled) return false;
    
    CGFloat target = [self targetForDirection:directon offset:offset];
    BOOL res = true;
    CGFloat min = [self minOffsetWithDirection:directon];
    if (target < min) {
        if ([self minBounceWithDirection:directon]) {
            target = [self targetForDirection:directon offset:[self springWithVerticalOffset:hi_rubberBandDistance(offset, size)]];
        } else {
            target = min;
            res = false;
        }
        
    } else {
        CGFloat maxOffsetSize = [self maxOffsetWithDirection:directon];
        if (target > maxOffsetSize) {
            if ([self maxBounceWithDirection:directon]) {
                target = [self targetForDirection:directon offset:[self springWithVerticalOffset:hi_rubberBandDistance(offset, size)]];
            } else {
                target = maxOffsetSize;
                res = false;
            }
        }
    }

    CGPoint point = HiScrollViewDirectionVertical == directon ? CGPointMake(0, target): CGPointMake(target, 0);
    [self updateContentOffset:point];
    
    return res;
}

- (CGPoint)resetPointForDirection:(HiScrollViewDirection)direction {
    CGFloat value = [self minOffsetWithDirection:direction];
    
    if ([self overBoundsWithDirection:direction] > 0 && ![self contentInSizeWithDirection:direction]) {
        value =  [self maxOffsetWithDirection:direction];
    }
    
    return HiScrollViewDirectionVertical == direction ? CGPointMake(0, value) : CGPointMake(value, 0);
}



/// MARK: - 容器调用
/// MARK: 控制上下滚动的方法
- (void)controlScrollOffset:(CGFloat)offset state:(UIGestureRecognizerState)state {
    
    self.actionScrollView = [self changeOffset:offset];
    if (UIGestureRecognizerStateEnded == state) [self resetScrollView];
}

/// MARK: 改变 offset
- (UIScrollView *)changeOffset:(CGFloat)offset {
    // 上 : offset < 0
    CGFloat size = [self sizeForDirection:self.scrollDirection];
    
    UIScrollView *actionScrollView = self.actionScrollView;
    if ([self.actionScrollView overSizeWithDirection:self.scrollDirection]) { // 当前处理滚动的 scroll view 没有回到原来的位置 优先 actionScrollView 响应
        [self.actionScrollView canChangeOffset:offset size:size direction:self.scrollDirection];
    } else {
        actionScrollView = [self actionScrollViewWithOffset:offset size:size];;
    }
    
    return actionScrollView;
}

/// MARK: 可以响应事件的 scroll view
- (UIScrollView *)actionScrollViewWithOffset:(CGFloat)offset size:(CGFloat)size {
    HiScrollNode *node = offset < 0 ? self.topNode : self.bottomNode;
    while (node && ![node.object canChangeOffset:offset size:size direction:self.scrollDirection]) {
        node = node.nextNode;
    }
    return node.object;
}

/// MARK: if oversize, resetsize
- (void)resetScrollView {
    UIScrollView *scrollView = self.actionScrollView;
    HiScrollViewDirection direction = self.scrollDirection;
    if ([scrollView overSizeWithDirection:direction]) {
        CGPoint target = [self resetPointForDirection:direction];
        [self springBehaviorWithTarget:target scrollView:scrollView];
    }
}

/// MARK: 添加线性加速 ,没有超过size
- (UIDynamicItemBehavior *)addInertialBehaviorWithVelocity:(CGPoint)velocity {
    UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
    
    [inertialBehavior addLinearVelocity:velocity forItem:self.dynamicItem];
    inertialBehavior.resistance = 2.3;
    __block CGPoint lastCenter = CGPointZero;
    __weak typeof(self) weak = self;
    inertialBehavior.action = ^{
        __strong typeof(weak) strong = weak;
        // 得到每次移动的距离
        CGFloat current = 0;
        if (HiScrollViewDirectionVertical == self.scrollDirection) {
            current = strong.dynamicItem.center.y - lastCenter.y;
        } else {
            current = strong.dynamicItem.center.x - lastCenter.x;
        }
        
        // 更新 actionScrollView
        [strong controlScrollOffset:current state:UIGestureRecognizerStateEnded];
        lastCenter = strong.dynamicItem.center;
    };
    return inertialBehavior;
}

@end
