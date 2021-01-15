//
//  HiScrollViewProperty.m
//  ScrollTest
//
//  Created by four on 2021/1/15.
//

#import "HiScrollViewProperty.h"
#import <objc/runtime.h>

@implementation UIScrollView (HiScrollViewProperty)

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

- (void)setHi_draggin:(BOOL)hi_draggin {
    SEL key = @selector(hi_draggin);
    objc_setAssociatedObject(self, key, @(hi_draggin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hi_draggin {
    SEL key = @selector(hi_draggin);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value boolValue];
}

@end
