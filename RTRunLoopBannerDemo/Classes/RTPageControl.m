//
//  RTPageControl.m
//  RTRunLoopBannerDemo
//
//  Created by ColaBean on 2017/6/21.
//  Copyright © 2017年 ColaBean. All rights reserved.
//

#import "RTPageControl.h"

@implementation RTPageControl

- (instancetype)init {
    if (self = [super init]) {
        _dotSize = 6.0f;
        _dotSpacing = 16.0f;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect frame = self.frame;
    //计算圆点间距
    CGFloat marginX = _dotSize + _dotSpacing;
    
    //计算整个pageControll的宽度
    CGFloat newW = [self widthForPageControl];
    
    //设置新frame
    frame = CGRectMake(frame.origin.x, frame.origin.y, newW, frame.size.height);
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(0 + i * marginX, (frame.size.height-_dotSize)*0.5, _dotSize, _dotSize)];
        }else {
            [dot setFrame:CGRectMake(0 + i * marginX, (frame.size.height-_dotSize)*0.5, _dotSize, _dotSize)];
        }
        dot.layer.cornerRadius = _dotSize * 0.5;
    }
    self.frame = frame;
}

- (void)setDotSize:(CGFloat)dotSize {
    if (dotSize<=0) {
        return;
    }
    _dotSize = dotSize;
}

- (void)setDotSpacing:(CGFloat)dotSpacing {
    if (dotSpacing<=0) {
        return;
    }
    _dotSpacing = dotSpacing;
}

- (CGFloat)widthForPageControl {
    if (self.numberOfPages == 0) {
        return 0;
    }
    return (self.subviews.count) * (_dotSize + _dotSpacing) - _dotSpacing;
}


@end
