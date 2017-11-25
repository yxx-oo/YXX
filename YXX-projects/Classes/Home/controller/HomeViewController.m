//
//  HomeViewController.m
//  yxxGod
//
//  Created by Yxx on 2017/11/22.
//  Copyright © 2017年 Yxx. All rights reserved.
//

#import "HomeViewController.h"
#import "YxxTopicsTableViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *recordStateBtn;
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIScrollView *contenView;

@end

static NSString *const yxxTextCell = @"text";

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏标题
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
//    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tap)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tap)];
    self.view.backgroundColor = YXXGlobalBg;
    
    //添加子控制器
    [self setupChildVces];
    [self setupTitlesView];
    [self setupContenView];
}

- (void)setupChildVces
{
    YxxTopicsTableViewController *all = [[YxxTopicsTableViewController alloc] init];
    all.title = @"推荐";
    all.type = YxxTopicsTypeAll;
    [self addChildViewController:all];
    
    YxxTopicsTableViewController *video = [[YxxTopicsTableViewController alloc] init];
    video.title = @"热门";
    video.type = YxxTopicsTypeVideo;
    [self addChildViewController:video];
    
    YxxTopicsTableViewController *voice = [[YxxTopicsTableViewController alloc] init];
    voice.title = @"主播";
    voice.type = YxxTopicsTypeVoice;
    [self addChildViewController:voice];
    
    YxxTopicsTableViewController *picture = [[YxxTopicsTableViewController alloc] init];
    picture.title = @"英雄";
    picture.type = YxxTopicsTypePicture;
    [self addChildViewController:picture];
    
}

- (void)setupContenView
{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contenView = [[UIScrollView alloc] init];
    //    contenView.backgroundColor = [UIColor redColor];
    contenView.frame = self.view.bounds;
    contenView.delegate = self;
    contenView.pagingEnabled = YES;
    //    contenView.contentInset = UIEdgeInsetsMake(99, 0, 49, 0);
    [self.view insertSubview:contenView atIndex:0];
    contenView.contentSize = CGSizeMake(contenView.width * self.childViewControllers.count, 0);
    
    self.contenView = contenView;
    
    //添加第一个控制器
    [self scrollViewDidEndScrollingAnimation:contenView];
}

- (void)setupTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    titlesView.width = self.view.width;
    titlesView.height = 35;
    titlesView.y = 0;
    [self.view addSubview:titlesView];
    self.titleView = titlesView;
    
    //底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = YXXNavigateBg;
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    //内部的子标签
    CGFloat width = titlesView.width/self.childViewControllers.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i<4; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.height = height;
        btn.width = width;
        btn.x = i*width;
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        //        [btn layoutIfNeeded];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:YXXNavigateBg forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:btn];
        if (i == 0) {
            btn.enabled = NO;
            self.recordStateBtn = btn;
            [btn.titleLabel sizeToFit];
            self.indicatorView.width = btn.titleLabel.width;
            self.indicatorView.centerX = btn.centerX;
            
        }
    }
    [titlesView addSubview:indicatorView];
    
}

- (void)titleClick:(UIButton *)button
{
    self.recordStateBtn.enabled = YES;
    button.enabled = NO;
    self.recordStateBtn = button;
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    //滑动
    CGPoint offset = self.contenView.contentOffset;
    offset.x = button.tag * self.contenView.width;
    [self.contenView setContentOffset:offset animated:YES];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    YxxTopicsTableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = CGRectGetMaxY(self.titleView.frame);
    vc.collectionView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    vc.collectionView.scrollIndicatorInsets = vc.collectionView.contentInset;
    [scrollView addSubview:vc.view];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    [self titleClick:self.titleView.subviews[index]];
}

- (void)tap
{
//    YxxSubscribeController *subscribe = [[YxxSubscribeController alloc] init];
//    [self.navigationController pushViewController:subscribe animated:YES];
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
