//
//  VerticalViewController.m
//  ScrollTest
//
//  Created by four on 2021/1/1.
//

#import "VerticalViewController.h"
#import "HiScrollView.h"
#import "MJRefresh/MJRefresh.h"

@interface VerticalViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;

@end

static CGFloat const contentOffset = 140;

@implementation VerticalViewController

- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] init];
        _backgroundScrollView.backgroundColor = UIColor.redColor;
        _backgroundScrollView.hi_scrollEnabled = true;
        _backgroundScrollView.topProperty = 1000;
        _backgroundScrollView.bottomProperty = 100;
    }
    return _backgroundScrollView;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = UIColor.orangeColor;
        _scrollView.hi_scrollEnabled = true;
        _scrollView.topProperty = 100;
        _scrollView.bottomProperty = 10;
        _scrollView.hi_refresh = true;
        _scrollView.bouncesInsets = HiBouncesInsetsMake(true, false, false, false);
    }
    return _scrollView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.hi_scrollEnabled = true;
        _tableView.topProperty = 10;
        _tableView.bottomProperty = 1000;
        _tableView.hi_refresh = true;
        _tableView.bouncesInsets = HiBouncesInsetsMake(false, false, true, false);
    }
    return _tableView;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.backgroundScrollView hi_scrollWithScrollDirection:HiScrollViewDirectionVertical];

    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"mj_footer");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer  endRefreshing];
        });
    }];
    
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"mj_header");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView.mj_header  endRefreshing];
        });
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.backgroundScrollView.frame = self.view.bounds;
    self.backgroundScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height + contentOffset);
    CGRect frame = CGRectMake(0, contentOffset, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.frame = frame;
    
    CGFloat margin = 44;
    self.tableView.frame = CGRectMake(0, margin, self.view.frame.size.width, self.view.frame.size.height - margin);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
}
@end