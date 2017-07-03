//
//  LJAdLoopBannerView.m
//  LJLiveOpenSDK
//
//  Created by ColaBean on 2017/6/2.
//  Copyright © 2017年 ColaBean. All rights reserved.
//

#import "LJAdLoopBannerView.h"

#import "RTRunnLoopBannerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LJAdLoopBannerView ()<RTRunLoopBannerViewDelegate, RTRunLoopBannerViewDataSource>
{
    RTRunnLoopBannerView *adView;
}

@end

@implementation LJAdLoopBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initBannerView];
    }
    return self;
}

- (void)initBannerView {
    adView = [[RTRunnLoopBannerView alloc] initWithFrame:self.bounds];
    adView.delegate = self;
    adView.dataSource = self;
    adView.pageIndicatorTintColor = [UIColor whiteColor];
    adView.currentPageIndicatorTintColor = [UIColor blackColor];
    adView.pageControlPos = RTPageControlShowPositionBottomRight;
    [self addSubview:adView];
}

- (void)setItemArray:(NSArray<NSString *> *)itemArray {
    _itemArray = itemArray;
    [adView reloadData];
}

- (void)stopRollBanner {
    [adView stop];
}

#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ RTRunLoopBannerViewDataSource ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
- (NSArray *)dataSourceInRunLoopBannerView:(RTRunnLoopBannerView *)bannerView {
    return _itemArray;
}

- (void)bannerView:(RTRunnLoopBannerView *)bannerView loadImageView:(UIImageView *)imgView atIndex:(NSUInteger)index {
    //定制化加载图片 可根据回调的索引 加载资源（静态图或URL）
    [imgView sd_setImageWithURL:[NSURL URLWithString:_itemArray[index]]];
}

#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ RTRunLoopBannerViewDelegate ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
- (void)bannerView:(RTRunnLoopBannerView *)bannerView didSelectedImageAtIndex:(NSInteger)index {
}

- (CGFloat)dotSize {
    return 6;
}

- (CGFloat)dotHorizontalSpacing {
    return 6;
}
@end
