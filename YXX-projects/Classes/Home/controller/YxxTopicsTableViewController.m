//
//  YxxTextTableViewController.m
//  百思不得姐
//
//  Created by Yxx on 16/4/14.
//  Copyright © 2016年 Yxx. All rights reserved.
//

#import "YxxTopicsTableViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "YxxTextModel.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "YxxDiscoveryCell.h"
//#import "YxxTextCell.h"
#define ItemMargin 5
@interface YxxTopicsTableViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy)   NSString *maxtime;
@property(nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@end

//static NSString *const yxxTextCell = @"text";

@implementation YxxTopicsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    [self CreatCollerctionView];
    [self setupRefresh];
}

- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

#pragma mark -创建流水布局
-(void)CreatCollerctionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    self.flowLayout = flowLayout;
    self.flowLayout.minimumLineSpacing = 5;
    self.flowLayout.minimumInteritemSpacing =2.5;
    self.collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [collectionView registerClass:[YxxDiscoveryCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = YXXGlobalBg;
}

//布局CollctionViewのsection
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-15)/2, (SCREEN_WIDTH-15)/2);
}

- (void)setupRefresh
{
//    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadNewTopics];
        
    }];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreTopics];
    }];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YxxTextCell class]) bundle:nil] forCellReuseIdentifier:yxxTextCell];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YxxDiscoveryCell *cell = (YxxDiscoveryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    cell.titleLabel.text = @"dafd";
    return cell;
}
//组之间的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(ItemMargin, ItemMargin, ItemMargin, ItemMargin);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YXXLog(@"%@", [NSString stringWithFormat:@"***dianji-%@",indexPath]);
    
}
- (void)loadNewTopics
{
    //请求参数
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"a"] = @"list";
    data[@"c"] = @"data";
    data[@"type"] = @(self.type);
    NSString *url = @"http://api.budejie.com/api/api_open.php";
    //发送请求
    [[AFHTTPSessionManager manager] GET:url parameters:data success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.maxtime = responseObject[@"info"][@"maxtime"];
        self.topics = [YxxTextModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.page = 0;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreTopics
{
    self.page++;
    //请求参数
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"a"] = @"list";
    data[@"c"] = @"data";
    data[@"type"] = @(self.type);
    data[@"page"] = @(self.page);
    data[@"maxtime"] = self.maxtime;
    NSString *url = @"http://api.budejie.com/api/api_open.php";
    //发送请求
    [[AFHTTPSessionManager manager] GET:url parameters:data success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        [self.topics addObjectsFromArray:[YxxTextModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.collectionView.mj_footer endRefreshing];
        self.page --;
        
    }];
    [self clearTmpPics];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.topics.count;
//
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//        static NSString *ID = @"cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//        }
////        YxxTextModel *textmodel = self.topics[indexPath.row];
////        cell.textLabel.text = textmodel.name;
////        cell.detailTextLabel.text = textmodel.text;
////        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:textmodel.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
////    YxxTextCell *textcell = [tableView dequeueReusableCellWithIdentifier:yxxTextCell];
////
////    textcell.topics = self.topics[indexPath.row];
////
//    return cell;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //取出帖子模型
//    YxxTextModel *topic = self.topics[indexPath.row];
//
//    return topic.cellHeight;
//}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
    NSLog(@"clear disk");
    
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    
    NSLog(@"%@",clearCacheName);
    
    [self.collectionView reloadData];
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
