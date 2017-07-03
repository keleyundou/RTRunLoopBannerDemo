//
//  RTRunnLoopBannerView.m
//  RTRunLoopBannerDemo
//
//  Created by ColaBean on 2017/6/21.
//  Copyright © 2017年 ColaBean. All rights reserved.
//

#import "RTRunnLoopBannerView.h"
#import "RTPageControl.h"

@interface RTBannerImageView : UIImageView
{
    id _target;
    SEL _action;
}

- (void)addTarget:(nullable id)target action:(SEL)action;
@end

@implementation RTBannerImageView
- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    
}

@end

@interface RTRunnLoopBannerView ()<UIScrollViewDelegate>
{
    CGFloat rt_width, rt_height;
    NSInteger rt_currentPage;
    NSInteger rt_pageCount;
    NSArray *assetBuffer;
    
    BOOL rt_doStop;
}

@property (nonatomic, strong) UIScrollView *rt_contentScrollView;

@property (nonatomic, strong) RTPageControl *rt_pageControl;

@property (nonatomic, strong) NSMutableArray <RTBannerImageView *>*bannerImageViewCacheBuffer;

@end

@implementation RTRunnLoopBannerView
@dynamic currentIndex, state;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bannerImageViewCacheBuffer = [NSMutableArray array];
        rt_currentPage = 0;
        _delay = 3.0f;
        _pageIndicatorTintColor = [UIColor blackColor];
        _currentPageIndicatorTintColor = [UIColor whiteColor];
        [self setupView];
        [self start];
    }
    return self;
}

- (void)setupView {
    //...
    [self addSubview:self.rt_contentScrollView];
    self.rt_contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupCells {
    //拿到pageCount后再构建buffer
    for (int i = 0; i < (rt_pageCount>1?3:rt_pageCount); i++) {
        RTBannerImageView *imgView = [[self class] createBannerImageViewWithTarget:self action:@selector(didBannerImageAction:)];
        [self.bannerImageViewCacheBuffer addObject:imgView];
    }
    
    [self layoutBannerImageViews];
}

- (void)layoutBannerImageViews {
    __block UIView *objContainerView = self.rt_contentScrollView;
    __block UIView *lastObjView = nil;
    [self.bannerImageViewCacheBuffer enumerateObjectsUsingBlock:^(RTBannerImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = NO;
        obj.tag = idx;
        [objContainerView addSubview:obj];
       
        [objContainerView addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:objContainerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [objContainerView addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:objContainerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [objContainerView addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:rt_width]];
        [objContainerView addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:rt_height]];
        
        if (lastObjView) {
            [objContainerView addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lastObjView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        } else {
            [objContainerView addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:objContainerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        }
        
        lastObjView = obj;
        
        if (idx == [self.bannerImageViewCacheBuffer count]-1) {
            [self addConstraintToScrollView:objContainerView lastView:lastObjView];
        }
    }];
}

- (void)addConstraintToScrollView:(UIView *)objContainerView lastView:(UIView *)lastView {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:objContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:objContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:objContainerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:objContainerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:objContainerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    rt_width = frame.size.width;
    rt_height = frame.size.height;
    self.rt_contentScrollView.frame = self.bounds;
    self.rt_contentScrollView.contentOffset = CGPointMake(rt_width, 0);
}

- (void)setDataSource:(id<RTRunLoopBannerViewDataSource>)dataSource {
    _dataSource = dataSource;
    assetBuffer = [dataSource dataSourceInRunLoopBannerView:self];
    rt_pageCount = [assetBuffer count];
    
    if (rt_pageCount <= 0) {
        [self stop];
        return;
    }
    
    if (rt_pageCount>=1) {
        [self setupCells];
        [self addSubview:self.rt_pageControl];
        if (rt_pageCount == 1) {
            _pageControlPos = RTPageControlShowPositionNone;
            self.rt_contentScrollView.scrollEnabled = NO;
            [self stop];
        }
        [self setPageControlPos:_pageControlPos];
        [self resetCurrentIndexImage:rt_currentPage];
    }
    
}

- (void)setDelegate:(id<RTRunLoopBannerViewDelegate>)delegate {
    _delegate = delegate;
    if (_delegate && [_delegate respondsToSelector:@selector(dotSize)]) {
        _rt_pageControl.dotSize = [_delegate dotSize];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(dotHorizontalSpacing)]) {
        _rt_pageControl.dotSpacing = [delegate dotHorizontalSpacing];
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    _rt_pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    _rt_pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageControlPos:(RTPageControlShowPosition)pageControlPos {
    _pageControlPos = pageControlPos;
    rt_pageCount = [[_dataSource dataSourceInRunLoopBannerView:self] count];
    if (!rt_pageCount) {
        return;
    }
    CGRect pageControlFrame = CGRectZero;
    switch (pageControlPos) {
        case RTPageControlShowPositionBottomLeft:
            pageControlFrame = CGRectMake(10, CGRectGetMaxY(self.rt_contentScrollView.frame)-30, 0, 30);
            break;
        case RTPageControlShowPositionBottomCenter:
            pageControlFrame = CGRectMake(self.center.x-[_rt_pageControl widthForPageControl:rt_pageCount]*0.5, CGRectGetMaxY(self.rt_contentScrollView.frame)-30, 0, 30);
            break;
        case RTPageControlShowPositionBottomRight:
            pageControlFrame = CGRectMake(rt_width-[_rt_pageControl widthForPageControl:rt_pageCount]-10, CGRectGetMaxY(self.rt_contentScrollView.frame)-30, 0, 30);
            break;
        case RTPageControlShowPositionCustom:
            if (_delegate && [_delegate respondsToSelector:@selector(customPageControlPostionWithBannerView:)]) {
                pageControlFrame = [_delegate customPageControlPostionWithBannerView:self];
            }
            break;
        default:
            [self.rt_pageControl removeFromSuperview];
            break;
    }
    self.rt_pageControl.frame = pageControlFrame;
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    _contentMode = contentMode;
    [self.bannerImageViewCacheBuffer enumerateObjectsUsingBlock:^(RTBannerImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentMode = contentMode;
    }];
}

//为横幅计算当前的索引
- (void)currentIndexCalculatedForBannerView {
    CGPoint offset = self.rt_contentScrollView.contentOffset;
    if (offset.x > rt_width) {
        rt_currentPage = (rt_currentPage+1)%rt_pageCount;
    } else if (offset.x < rt_width) {
        rt_currentPage = (rt_currentPage-1+rt_pageCount)%rt_pageCount;
    }
    [self resetCurrentIndexImage:rt_currentPage];
}

//根据索引重置3张视图的图片
- (void)resetCurrentIndexImage:(NSInteger)index {
    [self.bannerImageViewCacheBuffer enumerateObjectsUsingBlock:^(RTBannerImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger deltaIdx = 0;
        switch (idx) {
            case 0:
                deltaIdx = (index-1+rt_pageCount) %rt_pageCount;
                break;
            case 1:
                deltaIdx = (index) %rt_pageCount;
                break;
            case 2:
                deltaIdx = (index+1) %rt_pageCount;
                break;
            default:
                break;
        }
        if (_dataSource && [_dataSource respondsToSelector:@selector(bannerView:loadImageView:atIndex:)]) {
            [_dataSource bannerView:self loadImageView:obj atIndex:deltaIdx];
        }
//        [obj sd_setImageWithURL:[NSURL URLWithString:assetBuffer[deltaIdx]]];
    }];
    self.rt_pageControl.currentPage = index;
}

- (void)resetRunLoopImgs {
    [self currentIndexCalculatedForBannerView];
    self.rt_contentScrollView.contentOffset = CGPointMake(rt_width, 0);
    [self autoRunloop];
}

#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ UIScrollViewDelegate ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetRunLoopImgs];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self resetRunLoopImgs];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ Action ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
- (void)didBannerImageAction:(RTBannerImageView *)imageView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerView:didSelectedImageAtIndex:)]) {
        [_delegate bannerView:self didSelectedImageAtIndex:rt_currentPage];
    }
}

- (void)autoRunloop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
    [self performSelector:@selector(next) withObject:nil afterDelay:_delay];
}

- (void)next {
    [self.rt_contentScrollView setContentOffset:CGPointMake(2*rt_width, 0) animated:YES];
}

- (void)start {
    rt_doStop = NO;
//    [self autoRunloop];
}

- (void)stop {
    rt_doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

- (void)reloadData {
    [self setDataSource:_dataSource];
    [self setDelegate:_delegate];
    [self setPageControlPos:_pageControlPos];
    [self start];
}

- (UIScrollView *)rt_contentScrollView {
    if (!_rt_contentScrollView) {
        _rt_contentScrollView = [[UIScrollView alloc] init];
        _rt_contentScrollView.showsVerticalScrollIndicator = NO;
        _rt_contentScrollView.showsHorizontalScrollIndicator = NO;
        _rt_contentScrollView.pagingEnabled = YES;
        _rt_contentScrollView.delegate = self;
        _rt_contentScrollView.clipsToBounds = YES;
    }
    return _rt_contentScrollView;
}

- (RTPageControl *)rt_pageControl {
    if (!_rt_pageControl) {
        _rt_pageControl = [[RTPageControl alloc] init];
        _rt_pageControl.frame = CGRectZero;
        _rt_pageControl.currentPage = rt_currentPage;
        _rt_pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
        _rt_pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
        _rt_pageControl.numberOfPages = rt_pageCount;
        _rt_pageControl.userInteractionEnabled = NO;
        _rt_pageControl.dotSize = [_delegate dotSize];
        _rt_pageControl.dotSpacing = [_delegate dotHorizontalSpacing];
    }
    return _rt_pageControl;
}

- (NSInteger)currentIndex {
    return rt_currentPage;
}

- (RTRunLoopBannerViewShowState)state {
    return !rt_doStop;
}

+ (RTBannerImageView *)createBannerImageViewWithTarget:(id)target action:(SEL)action {
    RTBannerImageView *imgView = [RTBannerImageView new];
    [imgView addTarget:target action:action];
    return imgView;
}

@end
