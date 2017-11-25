//
//  YxxGuidePageView.m
//  百思不得姐
//
//  Created by Yxx on 16/4/14.
//  Copyright © 2016年 Yxx. All rights reserved.
//

#import "YxxGuidePageView.h"

@implementation YxxGuidePageView

+ (instancetype)guidePageView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (void)show
{
    //获取当前软件的版本号
    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    //获取沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    //获取window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (![currentVersion isEqualToString:sanboxVersion]) {
        YxxGuidePageView *guidePage = [YxxGuidePageView guidePageView];
        guidePage.frame = window.bounds;
        [window addSubview:guidePage];
    }
    //存储版本号
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)close {
    
    [self removeFromSuperview];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
