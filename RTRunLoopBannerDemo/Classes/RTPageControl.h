//
//  RTPageControl.h
//  RTRunLoopBannerDemo
//
//  Created by ColaBean on 2017/6/21.
//  Copyright © 2017年 ColaBean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTPageControl : UIPageControl
- (CGFloat)widthForPageControl:(NSInteger)numberOfPages;
@property (nonatomic, assign) CGFloat dotSize;// value > 0
@property (nonatomic, assign) CGFloat dotSpacing;// value > 0
@end
