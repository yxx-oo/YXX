//
//  YxxTabBar.m
//  百思不得姐
//
//  Created by Yxx on 16/3/16.
//  Copyright (c) 2016年 Yxx. All rights reserved.
//

#import "YxxTabBar.h"

@interface YxxTabBar()

@property (nonatomic, weak) UIButton *pulishButton;

@end

@implementation YxxTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
//        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
//        [self addSubview:publishButton];
//        self.pulishButton = publishButton;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    //设置发布按钮的frame
//    self.pulishButton.bounds = CGRectMake(0, 0, self.pulishButton.currentBackgroundImage.size.width, self.pulishButton.currentBackgroundImage.size.height);
//    self.pulishButton.center = CGPointMake(self.width*0.5, self.height*0.5);
//
//    NSInteger index = 0;
//    //设置其他UITabBarButton的frame
//    CGFloat buttonY = 0;
//    CGFloat buttonW = self.width/5;
//    CGFloat buttonH = self.height;
//    for (UIView *button in self.subviews) {
//        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
//
//        //计算按钮的X值
//        CGFloat buttonX = buttonW * ((index>1)?(index+1):index);
//        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
//        index ++;
//    }
}

@end

























