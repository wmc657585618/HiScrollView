//
//  ViewController.m
//  ScrollTest
//
//  Created by four on 2020/12/15.
//

#import "ViewController.h"
#import "VerticalViewController.h"
#import "HorizontalViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    CGFloat height = 44.0;
    CGFloat width = 100.0;
    CGFloat x = (self.view.frame.size.width - width) * 0.5;
    CGFloat y = self.view.frame.size.height * 0.5;
    
    UIButton *vertical = [UIButton buttonWithType:UIButtonTypeCustom];
    [vertical setTitle:@"vertical" forState:UIControlStateNormal];
    
    vertical.frame = CGRectMake(x, y - height, width, height);
    [vertical setTitleColor:UIColor.magentaColor forState:UIControlStateNormal];
    [self.view addSubview:vertical];
    
    
    UIButton *horizonal = [UIButton buttonWithType:UIButtonTypeCustom];
    [horizonal setTitle:@"horizonal" forState:UIControlStateNormal];
    
    horizonal.frame = CGRectMake(x, y + height, width, height);
    [horizonal setTitleColor:UIColor.magentaColor forState:UIControlStateNormal];
    [self.view addSubview:horizonal];
    
    [vertical addTarget:self action:@selector(vertical) forControlEvents:UIControlEventTouchUpInside];
    [horizonal addTarget:self action:@selector(horizonal) forControlEvents:UIControlEventTouchUpInside];
}

- (void)vertical {
    [self.navigationController pushViewController:[[VerticalViewController alloc] init] animated:true];
}

- (void)horizonal {
    [self.navigationController pushViewController:[[HorizontalViewController alloc] init] animated:true];
}

@end
