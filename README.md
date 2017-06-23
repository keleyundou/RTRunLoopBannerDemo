## RTRunLoopBanner

一个轮播控件

## Usage

+ 初始化

```objc
    self.bannerView = [[RTRunnLoopBannerView alloc] initWithFrame:(CGRect){0,100,SCREEN_WIDTH, 100}];
    self.bannerView.backgroundColor = [UIColor blackColor];
    _bannerView.dataSource = self;
    _bannerView.delegate = self;
    _bannerView.pageIndicatorTintColor = [UIColor redColor];
    _bannerView.currentPageIndicatorTintColor = [UIColor greenColor];
    _bannerView.pageControlPos = RTPageControlShowPositionBottomCenter;
    [self.view addSubview:_bannerView];

```

+ callback

```objc
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

```
