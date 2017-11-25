//
//  YxxTabBarController.m
//  百思不得姐
//
//  Created by Yxx on 16/3/16.
//  Copyright (c) 2016年 Yxx. All rights reserved.
//

#import "YxxTabBarController.h"
#import "YxxTabBar.h"
#import "YxxNavigationController.h"
#import "HomeViewController.h"

@interface YxxTabBarController ()

@end

@implementation YxxTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    UIImage *image = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    //    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    vc01.tabBarItem.selectedImage = image;
    //    vc01.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    // 添加子控制器
//    UIViewController *vc01 = [[UIViewController alloc] init];
//    vc01.tabBarItem.title = @"精华";
//    vc01.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
//    vc01.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_click_icon"];
//    //设置文字颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dict[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedDict = [NSMutableDictionary dictionary];
    selectedDict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedDict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:dict forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
    
    [self setupClickVC:[[HomeViewController alloc] init] title:@"精华" image:@"tabBarIcon-recommend-normal" seletedImage:@"tabBarIcon-recommend-selected"];
//    [self setupClickVC:[[YxxNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" seletedImage:@"tabBar_new_click_icon"];
//    [self setupClickVC:[[YxxFriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" seletedImage:@"tabBar_friendTrends_click_icon"];
//    [self setupClickVC:[[YxxMeViewController alloc] init] title:@"我" image:@"tabBar_me_icon" seletedImage:@"tabBar_me_click_icon"];
//    [self addChildViewController:vc01];
    
    //更换tabbar(KVC)
    [self setValue:[[YxxTabBar alloc] init] forKeyPath:@"tabBar"];
    
}

- (void)setupClickVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image seletedImage:(NSString *)seletedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:seletedImage];
    vc.hidesBottomBarWhenPushed = YES;
    
    //包装一个导航控制器，添加导航控制器为tabbarcontroller的子控制器
    YxxNavigationController *nav = [[YxxNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end























