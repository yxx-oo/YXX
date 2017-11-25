//
//  YxxTextModel.h
//  百思不得姐
//
//  Created by Yxx on 16/4/20.
//  Copyright © 2016年 Yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YxxTextModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *profile_image;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger ding;
@property (nonatomic, assign) NSInteger cai;
@property (nonatomic, assign) NSInteger repost;
@property (nonatomic, assign) NSInteger coment;
@property (nonatomic, assign, getter=isSina_v) BOOL sina_v;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *small_ImageUrl;
@property (nonatomic, copy) NSString *large_ImageUrl;
@property (nonatomic, copy) NSString *middle_ImageUrl;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
