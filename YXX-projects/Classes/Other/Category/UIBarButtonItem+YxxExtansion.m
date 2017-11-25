//
//  UIBarButtonItem+YxxExtansion.m
//  百思不得姐
//
//  Created by Yxx on 16/3/17.
//  Copyright (c) 2016年 Yxx. All rights reserved.
//

#import "UIBarButtonItem+YxxExtansion.h"

@implementation UIBarButtonItem (YxxExtansion)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)hithImage target:(id)target action:(SEL)action
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hithImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

@end
