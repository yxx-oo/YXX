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

//{
//data: [
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 孙悟空小峰老师开课了!",
//    duration: 1198,
//    thumb: "https://vthumb.ykimg.com/054104085A0AA4BC0000011036076F03",
//    uploadDate: "2017-11-14 18:33:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzE1NzI0MDU5Mg==.html",
//    pageURLMD5: "0289fb6c61f417d44397f2d37af54ac7",
//    leftSize: 1
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 梦奇全物理出装高输出新玩法!",
//    duration: 878,
//    thumb: "https://vthumb.ykimg.com/0541010159FAD871ADD0168A5D98A68C",
//    uploadDate: "2017-11-02 16:38:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzEyOTExMTgwNA==.html",
//    pageURLMD5: "0cbe6299848e93bdd0be79e39898d4ac",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 百里守约, 拿超神MVP真的很守约",
//    duration: 1115,
//    thumb: "https://vthumb.ykimg.com/054101015A1678E9E4DD0781B591ED64",
//    uploadDate: "2017-11-24 10:38:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzE3ODkxNTYxNg==.html",
//    pageURLMD5: "13ff6234e767d71b47e18fd606843953",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 王者排位孙悟空一棍逆风翻盘",
//    duration: 1195,
//    thumb: "https://vthumb.ykimg.com/0541010159EAB927ADC95BA6A19023B8",
//    uploadDate: "2017-10-21 11:09:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzA5OTg2MzU4NA==.html",
//    pageURLMD5: "479ef99c5688692327a12ef3630dd83f",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, S9赛季百里守约正确出装打56%输出",
//    duration: 774,
//    thumb: "https://vthumb.ykimg.com/0541010159F4096E8B324C7D8823C211",
//    uploadDate: "2017-10-28 12:53:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzExNjY2MjE4OA==.html",
//    pageURLMD5: "62c8039efbf8427b3e53a211da79ef82",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 新英雄女娲尼罗河女神吊打各种小朋友",
//    duration: 872,
//    thumb: "https://vthumb.ykimg.com/054101015A1A4AD08B32557E786795EA",
//    uploadDate: "2014-05-01 10:38:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzE4NTQ2NDQwNA==.html",
//    pageURLMD5: "6494e9930a567aad10274fb3ca78fb63",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 李白常规操作日常带飞!",
//    duration: 1257,
//    thumb: "https://vthumb.ykimg.com/0541010159FE8103ADC95B8C5E41B09C",
//    uploadDate: "2017-11-05 11:16:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzEzNTYyMzg3Ng==.html",
//    pageURLMD5: "649c437af8c2f3cfa90727ec1edadeaf",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 久违的孙尚香杀手不太冷",
//    duration: 1127,
//    thumb: "https://vthumb.ykimg.com/0541010159E869F08B3255A4B7527C93",
//    uploadDate: "2017-10-19 17:06:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzA5NTkwNjI3Mg==.html",
//    pageURLMD5: "66e4ac57ab59e94ab1fd6206b2e959bd",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 嬴政带节奏以弱胜强!",
//    duration: 1722,
//    thumb: "https://vthumb.ykimg.com/054101015A00A0C68B32557E792AEE5D",
//    uploadDate: "2017-11-07 01:54:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzEzOTQ4NzEyNA==.html",
//    pageURLMD5: "72433e5fd742e04a0a5a7a52b54a90df",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 女娲四技能抢先体验!",
//    duration: 883,
//    thumb: "https://vthumb.ykimg.com/0541010159F55B40ADD01688AD865AB4",
//    uploadDate: "2017-10-29 12:43:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzExODkyNjkyMA==.html",
//    pageURLMD5: "78c9ce5fdafb6a90849013ee58385d27",
//    leftSize: 2
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 铠哥, S9加强英雄值得推荐",
//    duration: 1015,
//    thumb: "https://vthumb.ykimg.com/054101015A07ED518B32557E7245C935",
//    uploadDate: "2017-11-12 14:48:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzE1MjUxNzMxNg==.html",
//    pageURLMD5: "7c5da761a892226adacfe2d6950f524c",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 扁鹊加强后1打9好像没问题",
//    duration: 1288,
//    thumb: "https://vthumb.ykimg.com/054101015A0EA1378B7B448838B10A86",
//    uploadDate: "2017-11-17 17:03:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzE2MzY5ODYyMA==.html",
//    pageURLMD5: "a74644089bcda7feb2ed821d6267eb7d",
//    leftSize: 4
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 旧赛季马可波罗逆风超神拿MVP!",
//    duration: 1134,
//    thumb: "https://vthumb.ykimg.com/0541010159E78E558B324C9FB1CDD100",
//    uploadDate: "2017-10-19 01:31:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzA5NDU1NjU4OA==.html",
//    pageURLMD5: "adf8a7a2f1e8f3f32b4f5fe42dcf8a68",
//    leftSize: 0
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 孙悟空铭文出装及玩法详细解说!",
//    duration: 1004,
//    thumb: "https://vthumb.ykimg.com/0541010159FD6500ADC95B8C58ED9B72",
//    uploadDate: "2017-11-04 15:03:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzEzMzc4NDQ4OA==.html",
//    pageURLMD5: "c20a369fb327d67398321f6076661d7a",
//    leftSize: 2
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 孙尚香杀手不太冷又来秀一波",
//    duration: 1044,
//    thumb: "https://vthumb.ykimg.com/054101015A139CD58B32557E74512094",
//    uploadDate: "2017-11-22 10:38:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzE3Mjg1NDkxMg==.html",
//    pageURLMD5: "cda053fb8dc1927d23b84b562e7cb8fe",
//    leftSize: 1
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰新游试玩, 都知道王者荣耀, 这款横版MOBA超能战队你玩过吗",
//    duration: 1207,
//    thumb: "https://vthumb.ykimg.com/054101015A091CE78B7B4488356A5582",
//    uploadDate: "2017-11-13 12:24:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzE1NDM4MjEwOA==.html",
//    pageURLMD5: "d769fcc797ef4ea953a190da688ebe9a",
//    leftSize: 1
//    },
//    {
//        id: null,
//    playerId: "1",
//    title: "裴小峰王者荣耀, 开局低迷时被队友激将法李白瞬间爆发!",
//    duration: 1090,
//    thumb: "https://vthumb.ykimg.com/054101015A0FE4C98B3C4684265299B0",
//    uploadDate: "2017-11-18 15:52:00.0",
//    pageURL: "http://v.youku.com/v_show/id_XMzE2NjM1NDE2NA==.html",
//    pageURLMD5: "eee9fc8012f0174ed7cb1374f90031aa",
//    leftSize: 0
//    }
//       ],
//msg: "Success",
//code: "0"
//}

@end
