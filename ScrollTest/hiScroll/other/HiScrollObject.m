//
//  HiScrollObject.m
//  ScrollTest
//
//  Created by four on 2020/12/29.
//

#import "HiScrollObject.h"

@interface HiScrollTimer ()

@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation HiScrollTimer

- (void)resumeTimerInterval:(CGFloat)interval synce:(void(^)(void))block {
    
    [self destroyTimer];
    
    if (block) {
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
        
        dispatch_source_set_timer(_timer, start, (uint64_t)(interval * NSEC_PER_SEC), 0);
        
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), block);
        });
        
        dispatch_resume(self.timer);
    }
}

- (void)afterInterval:(CGFloat)interval synce:(void(^)(void))block{
    
    __weak typeof(self) weak = self;
    [self resumeTimerInterval:interval synce:^{
        __strong typeof(weak) strong = weak;
        [strong destroyTimer];
        
        if (block) block();
    }];
}

- (void)destroyTimer {
    if (self.timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)dealloc {
    [self destroyTimer];
}

@end

@implementation HiDynamicItem

- (instancetype)init {
    if (self = [super init]) {
        _bounds = CGRectMake(0, 0, 1, 1);
    }
    return self;
}

@end

@implementation HiScrollWeak

@end

@interface HiScrollGesture ()

@property (nonatomic, assign) BOOL addGesture;

@end

@implementation HiScrollGesture

/// MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([self.delegate respondsToSelector:@selector(gesture:shouldReceiveTouch:)]) {
        [self.delegate gesture:gestureRecognizer shouldReceiveTouch:touch];
    }
    return false;
}

- (void)panAction:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(panGestureRecognizerAction:)]) {
        [self.delegate panGestureRecognizerAction:gestureRecognizer];
    }
}

/// MARK: - public
- (void)addGestureAtView:(UIView *)view {
    if (self.addGesture) return;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.cancelsTouchesInView = false;
    [view addGestureRecognizer:pan];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    tap.delegate = self;
    [view addGestureRecognizer:tap];
}

@end

@implementation HiScrollNode

@end
