//
//  HiScrollViewPropertyVertical.m
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import "HiScrollViewPropertyVertical.h"
#import "HiScrollViewPublic.h"
#import <objc/runtime.h>

@implementation UIScrollView (HiScrollViewPropertyVertical)

- (BOOL)overVerticalSize {
    return self.overVerticalBounds != 0;
}

- (CGFloat)overVerticalBounds {
    if (self.contentOffset.y < self.minVerticalTop) return self.contentOffset.y - self.minVerticalTop;
    if (self.maxVerticalBottom < self.frame.size.height) return self.contentOffset.y;
    CGFloat s = self.frame.size.height + self.contentOffset.y - self.maxVerticalBottom;
    if (s > 0) return s;
    return 0;
}

- (CGFloat)maxVerticalBottom {
    return self.contentSize.height + self.contentInset.bottom;
}

- (CGFloat)minVerticalTop {
    return -self.contentInset.top;
}

- (CGFloat)maxVerticalOffset {
    CGFloat value = self.maxVerticalBottom - self.frame.size.height;
    if (value > 0) return value;
    return self.maxVerticalBottom;
}

@end
