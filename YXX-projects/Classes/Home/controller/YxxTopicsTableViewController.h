//
//  YxxTopicsTableViewController.h
//  百思不得姐
//
//  Created by Yxx on 16/4/22.
//  Copyright © 2016年 Yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YxxTopicsTypeAll = 1,
    YxxTopicsTypePicture = 10,
    YxxTopicsTypeVoice = 31,
    YxxTopicsTypeText = 29,
    YxxTopicsTypeVideo = 41
}YxxTopicsType;

@interface YxxTopicsTableViewController : UIViewController

@property (nonatomic, assign) YxxTopicsType type;
@property(nonatomic,strong) UICollectionView *collectionView;
@end
