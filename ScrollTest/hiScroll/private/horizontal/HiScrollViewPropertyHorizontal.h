//
//  HiScrollViewPropertyHorizontal.h
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HiScrollViewPropertyHorizontal)

@property (nonatomic, assign, readonly) BOOL overHorizontalSize; // 超过内容size
@property (nonatomic, assign, readonly) CGFloat overHorizontalBounds; // 超过内容size的部分
@property (nonatomic, assign, readonly) CGFloat maxHorizontalRight; // 最大的 内容展示区 右侧
@property (nonatomic, assign, readonly) CGFloat minHorizontalLeft; // 最大的 内容展示区 左侧
@property (nonatomic, assign, readonly) CGFloat maxHorizontalOffset;

@end

NS_ASSUME_NONNULL_END
