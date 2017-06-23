//
//  RTRunnLoopBannerView.h
//  RTRunLoopBannerDemo
//
//  Created by ColaBean on 2017/6/21.
//  Copyright © 2017年 ColaBean. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RTPageControlShowPosition) {
    RTPageControlShowPositionBottomCenter,
    RTPageControlShowPositionBottomLeft,
    RTPageControlShowPositionBottomRight,
    RTPageControlShowPositionCustom,//需实现相关delegate方法
    RTPageControlShowPositionNone,
};

typedef NS_ENUM(NSUInteger, RTRunLoopBannerViewShowState) {
    RTRunLoopBannerViewShowStateStoped,
    RTRunLoopBannerViewShowStateStarted,
};

@class RTRunnLoopBannerView;
//dataSource
@protocol RTRunLoopBannerViewDataSource <NSObject>

@required
- (NSArray *_Nullable)dataSourceInRunLoopBannerView:(RTRunnLoopBannerView *_Nullable)bannerView;
- (void)bannerView:(RTRunnLoopBannerView *_Nullable)bannerView loadImageView:(UIImageView *_Nullable)imgView atIndex:(NSUInteger)index;
@end

@protocol RTRunLoopBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(RTRunnLoopBannerView *_Nullable)bannerView didSelectedImageAtIndex:(NSInteger)index;
- (CGRect)customPageControlPostionWithBannerView:(RTRunnLoopBannerView *_Nullable)bannerView;//待优化
- (CGFloat)dotSize;///< 点大小
- (CGFloat)dotHorizontalSpacing;///< 点与点水平间距
@end

@interface RTRunnLoopBannerView : UIView

@property (nonatomic, weak, nullable) id <RTRunLoopBannerViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <RTRunLoopBannerViewDelegate> delegate;
@property (nonatomic, strong) UIColor * _Nullable pageIndicatorTintColor;
@property (nonatomic, strong) UIColor * _Nullable currentPageIndicatorTintColor;
@property (nonatomic, assign) CGFloat delay;///< 滑动间隔
@property (nonatomic, assign) RTPageControlShowPosition pageControlPos;
@property (nonatomic, assign) UIViewContentMode contentMode;

@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign, readonly) RTRunLoopBannerViewShowState state;

///默认开启
- (void)start;
- (void)stop;

@end

