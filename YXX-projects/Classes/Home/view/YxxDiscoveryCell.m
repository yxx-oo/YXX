//
//  DiscoveryCell.m
//  App
//
//  Created by 张丁豪 on 16/9/7.
//  Copyright © 2016年 张丁豪. All rights reserved.
//
// GitHub地址: https://github.com/CalvinCheungCoder/eyepetizer
// 个人博客: http://www.zhangdinghao.cn
// QQ: 984382258 欢迎一起学习交流

#import "YxxDiscoveryCell.h"

#define selfCornerRadius 5;
@interface YxxDiscoveryCell()

@end

@implementation YxxDiscoveryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = selfCornerRadius;
        _ImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width*0.56)];
        _ImageView.backgroundColor = [UIColor grayColor];
        _ImageView.image = [UIImage imageNamed:@"test"];
        _ImageView.layer.cornerRadius = selfCornerRadius;
        _ImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_ImageView];
        
//        _shadeView = [[UIImageView alloc]initWithFrame:self.bounds];
//        _shadeView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
//        [self.contentView addSubview:_shadeView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2-20, self.bounds.size.width, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
//        _titleLabel.font = [UIFont fontWithName:MyChinFont size:16.f];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

@end
