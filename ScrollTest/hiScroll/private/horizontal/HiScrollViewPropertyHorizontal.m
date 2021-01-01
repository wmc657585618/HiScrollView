//
//  HiScrollViewPropertyHorizontal.m
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import "HiScrollViewPropertyHorizontal.h"
#import "HiScrollViewPublic.h"
#import <objc/runtime.h>

@implementation UIScrollView (HiScrollViewPropertyHorizontal)

- (BOOL)overHorizontalSize {
    return self.overHorizontalBounds != 0;
}

- (CGFloat)overHorizontalBounds {
    if (self.contentOffset.x < self.minHorizontalLeft) return self.contentOffset.x - self.minHorizontalLeft;
    if (self.maxHorizontalRight < self.frame.size.width) return self.contentOffset.x;
    CGFloat s = self.frame.size.width + self.contentOffset.x - self.maxHorizontalRight;
    if (s > 0) return s;
    return 0;
}

- (CGFloat)maxHorizontalRight {
    return self.contentSize.width + self.contentInset.right;
}

- (CGFloat)minHorizontalLeft {
    return -self.contentInset.left;
}

- (CGFloat)maxHorizontalOffset {
    CGFloat value = self.maxHorizontalRight - self.frame.size.width;
    if (value > 0) return value;
    return self.maxHorizontalRight;
}

@end
