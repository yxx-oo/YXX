//
//  YxxTextModel.m
//  百思不得姐
//
//  Created by Yxx on 16/4/20.
//  Copyright © 2016年 Yxx. All rights reserved.
//

#import "YxxTextModel.h"
#import <MJExtension.h>

@interface YxxTextModel ()
{
    CGFloat _cellHeight;
}
@end

@implementation YxxTextModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    NSDictionary *dict = @{
                           @"small_ImageUrl" : @"image0",
                           @"large_ImageUrl" : @"image1",
                           @"middle_ImageUrl" : @"image2"
    };
    return dict;
}

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        CGFloat textY = 55;
        CGSize macSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-40, MAXFLOAT);
        //    CGFloat textH = [topic.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:macSize].height;
        CGFloat textH = [self.text boundingRectWithSize:macSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        _cellHeight = textY+textH+64;
        if ([self.type isEqualToString:@"10"]) {
            CGFloat imageW = macSize.width;
            CGFloat imageH = imageW * self.height / self.width;

            _cellHeight += imageH;
            
        }
    }
    
    return _cellHeight;
}

@end
