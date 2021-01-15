//
//  HiScrollViewPublic.m
//  ScrollTest
//
//  Created by four on 2020/12/29.
//

#import "HiScrollViewPublic.h"
#import <objc/runtime.h>

@implementation UIScrollView (HiScrollViewPublic)

- (void)setHi_scrollEnabled:(BOOL)hi_scrollEnabled {
    self.scrollEnabled = false;
    SEL key = @selector(hi_scrollEnabled);
    objc_setAssociatedObject(self, key, [NSNumber numberWithBool:hi_scrollEnabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hi_scrollEnabled {
    SEL key = @selector(hi_scrollEnabled);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value boolValue];
}

- (void)setBouncesInsets:(HiBouncesInsets)bouncesInsets {
    NSValue *value = [NSValue valueWithBytes:&bouncesInsets objCType:@encode(HiBouncesInsets)];
    if (value) {
        SEL key = @selector(bouncesInsets);
        objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (HiBouncesInsets)bouncesInsets {
    SEL key = @selector(bouncesInsets);
    NSValue *value = objc_getAssociatedObject(self, key);
    HiBouncesInsets bouncesInsets = HiBouncesInsetsMake(false, false, false, false);
    [value getValue:&bouncesInsets];
    return bouncesInsets;
}

- (void)setTopProperty:(NSInteger)topProperty {
    SEL key = @selector(topProperty);
    objc_setAssociatedObject(self, key, @(topProperty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)topProperty {
    SEL key = @selector(topProperty);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value integerValue];
}

- (void)setBottomProperty:(NSInteger)bottomProperty {
    SEL key = @selector(bottomProperty);
    objc_setAssociatedObject(self, key, @(bottomProperty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)bottomProperty {
    SEL key = @selector(bottomProperty);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value integerValue];
}

- (void)setLeftProperty:(NSInteger)leftProperty {
    SEL key = @selector(leftProperty);
    objc_setAssociatedObject(self, key, @(leftProperty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)leftProperty {
    SEL key = @selector(leftProperty);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value integerValue];
}

- (void)setRightProperty:(NSInteger)rightProperty {
    SEL key = @selector(rightProperty);
    objc_setAssociatedObject(self, key, @(rightProperty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)rightProperty {
    SEL key = @selector(rightProperty);
    NSNumber *value = objc_getAssociatedObject(self, key);
    return [value integerValue];
}

@end
