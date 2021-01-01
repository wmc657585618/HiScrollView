//
//  HiScrollViewPropertyVertical.h
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HiScrollViewPropertyVertical)

@property (nonatomic, assign, readonly) BOOL overVerticalSize; // 超过内容size
@property (nonatomic, assign, readonly) CGFloat overVerticalBounds; // 超过内容size的部分
@property (nonatomic, assign, readonly) CGFloat maxVerticalBottom; // 最大的 内容展示区 底部
@property (nonatomic, assign, readonly) CGFloat minVerticalTop; // 最小的 内容展示区 顶部
@property (nonatomic, assign, readonly) CGFloat maxVerticalOffset;// 最大的 contentOffset

@end

NS_ASSUME_NONNULL_END
