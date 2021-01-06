//
//  HiScrollViewPublic.h
//  ScrollTest
//
//  Created by four on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "HiScrollViewDefine.h"

typedef struct __attribute__((objc_boxable)) HiBouncesInsets {
    BOOL top, left, bottom, right;
} HiBouncesInsets;

UIKIT_STATIC_INLINE HiBouncesInsets HiBouncesInsetsMake(BOOL top, BOOL left, BOOL bottom, BOOL right) {
    HiBouncesInsets insets = {top, left, bottom, right};
    return insets;
}

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HiScrollViewPublic)

@property (nonatomic, assign) BOOL hi_scrollEnabled; // 会禁用原来的scroll, scrollEnabled = false.

@property (nonatomic, assign) HiBouncesInsets bouncesInsets; // default is false.

@property (nonatomic, assign) NSInteger topProperty; // top 响应优先级. default is 0.
@property (nonatomic, assign) NSInteger bottomProperty;
@property (nonatomic, assign) NSInteger leftProperty;
@property (nonatomic, assign) NSInteger rightProperty;

@end

NS_ASSUME_NONNULL_END
