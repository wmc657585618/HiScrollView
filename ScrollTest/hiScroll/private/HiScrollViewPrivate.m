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

- (BOOL)contentInSize {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            return self.maxVerticalBottom < self.frame.size.height;

        case HiScrollViewDirectionHorizontal:
            return self.maxHorizontalRight < self.frame.size.width;
    }
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
    if (self.hi_refresh) return self.hi_draggin;
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

@end
