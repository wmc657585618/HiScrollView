//
//  HorizontalViewController.m
//  ScrollTest
//
//  Created by four on 2021/1/1.
//

#import "HorizontalViewController.h"
#import "HiScrollView.h"

@interface HorizontalViewController ()

@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *content;

@end

static CGFloat const contentOffset = 140;

@implementation HorizontalViewController

- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] init];
        _backgroundScrollView.backgroundColor = UIColor.redColor;
        _backgroundScrollView.hi_scrollEnabled = true;
        _backgroundScrollView.leftProperty = 1000;
        _backgroundScrollView.rightProperty = 100;
    }
    return _backgroundScrollView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = UIColor.orangeColor;
        _scrollView.hi_scrollEnabled = true;
        _scrollView.leftProperty = 100;
        _scrollView.rightProperty = 10;
        _scrollView.bouncesInsets = HiBouncesInsetsMake(false, true, false, false);
    }
    return _scrollView;
}

- (UIView *)content {
    if (!_content) {
        _content = [[UIView alloc] init];
        _content.backgroundColor = UIColor.whiteColor;
    }
    return _content;
}


- (void)viewDidLoad {

    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.backgroundScrollView hi_scrollWithScrollDirection:HiScrollViewDirectionHorizontal];
    
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.scrollView];
    [self.scrollView addSubview:self.content];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.backgroundScrollView.frame = self.view.bounds;
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width + contentOffset,0);
    CGRect frame = CGRectMake(contentOffset, 0, self.view.frame.size.width - contentOffset, self.view.frame.size.height);
    self.scrollView.frame = frame;
    
    self.content.frame = CGRectMake(100, 0, 44, self.scrollView.frame.size.height);
}

@end
