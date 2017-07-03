//
//  ViewController.m
//  RTRunLoopBannerDemo
//
//  Created by ColaBean on 2017/6/21.
//  Copyright © 2017年 ColaBean. All rights reserved.
//

#import "ViewController.h"
#import "RTRunnLoopBannerView.h"
#import "LJAdLoopBannerView.h"

@import AVFoundation;
@interface ViewController ()<RTRunLoopBannerViewDataSource, RTRunLoopBannerViewDelegate>
{
    NSArray *dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RTRunnLoopBannerView *bannerView;
@property (nonatomic, strong) LJAdLoopBannerView *adView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self dummy];
//    [self.view addSubview:self.bannerView];
//    self.tableView.tableHeaderView = self.adView;
}

- (RTRunnLoopBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[RTRunnLoopBannerView alloc] initWithFrame:(CGRect){0,100,SCREEN_WIDTH, 100}];
        self.bannerView.backgroundColor = [UIColor blackColor];
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        _bannerView.pageIndicatorTintColor = [UIColor redColor];
        _bannerView.currentPageIndicatorTintColor = [UIColor greenColor];
        _bannerView.pageControlPos = RTPageControlShowPositionBottomCenter;
    }
    return _bannerView;
}

- (LJAdLoopBannerView *)adView {
    if (!_adView) {
        _adView = [[LJAdLoopBannerView alloc] initWithFrame:(CGRect){0,100,SCREEN_WIDTH, 100}];
    }
    return _adView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dummy {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dataSource = @[
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2140194120,3181925453&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3799095963,2162924214&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2034155823,1607024698&fm=26&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1780551420,534652445&fm=26&gp=0.jpg",
                       ];
//        [_bannerView reloadData];
//        self.tableView.tableHeaderView = self.bannerView;
//        [self.bannerView reloadData];
        self.tableView.tableHeaderView = self.adView;
        [self.adView setItemArray:dataSource];
        [self.tableView reloadData];
    });
}

#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ RTRunLoopBannerViewDataSource ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
- (NSArray *)dataSourceInRunLoopBannerView:(RTRunnLoopBannerView *)bannerView {
    return dataSource;
}

- (void)bannerView:(RTRunnLoopBannerView *)bannerView loadImageView:(UIImageView *)imgView atIndex:(NSUInteger)index {
    //定制化加载图片 可根据回调的索引 加载资源（静态图或URL）
    [imgView sd_setImageWithURL:[NSURL URLWithString:dataSource[index]]];
}

#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ RTRunLoopBannerViewDelegate ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
- (void)bannerView:(RTRunnLoopBannerView *)bannerView didSelectedImageAtIndex:(NSInteger)index {
    NSLog(@"did current image index : %ld", index);
}

- (CGRect)customPageControlPostionWithBannerView:(RTRunnLoopBannerView *)bannerView {
    return (CGRect){10,0,0,30};
}

- (CGFloat)dotSize {
    return 10;
}

- (CGFloat)dotHorizontalSpacing {
    return 10;
}

#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ TableView ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

#pragma mark - TableView 代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellReuseIdentifier = @"xxxxxx";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


@end
