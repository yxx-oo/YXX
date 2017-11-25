//
//  YxxNavigationController.m
//  百思不得姐
//
//  Created by Yxx on 16/3/17.
//  Copyright (c) 2016年 Yxx. All rights reserved.
//

#import "YxxNavigationController.h"

@interface YxxNavigationController ()

@end

@implementation YxxNavigationController

//当第一次使用这个类的时候会调用一次
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"cm4_topbar_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.backgroundColor = YXXNavigateBg;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        backButton.size = CGSizeMake(100, 30);
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //这句super的push要放在后面，让viewController可以覆盖上面设置的leftButtonItem
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end





























