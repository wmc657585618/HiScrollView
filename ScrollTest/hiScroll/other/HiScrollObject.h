//
//  HiScrollObject.h
//  ScrollTest
//
//  Created by four on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HiScrollGestureDelegate <NSObject>
@optional
- (void)gesture:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer;

@end

@interface HiScrollTimer : NSObject

- (void)afterInterval:(CGFloat)interval synce:(void(^)(void))block;
- (void)destroyTimer;
@end

@interface HiDynamicItem : NSObject<UIDynamicItem>

@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readwrite) CGAffineTransform transform;

@end

@interface HiScrollWeak : NSObject

@property (nonatomic, weak) id objc;

@end

@interface HiScrollGesture : NSObject<UIGestureRecognizerDelegate>

- (void)addGestureAtView:(UIView *)view;

@property (nonatomic, weak) id<HiScrollGestureDelegate> delegate;

@end

@interface HiScrollNode : NSObject

@property (nonatomic, strong) HiScrollNode * __nullable lastNode;
@property (nonatomic, strong) HiScrollNode * __nullable nextNode;
@property (nonatomic, weak) UIScrollView *object;

@end

NS_ASSUME_NONNULL_END
