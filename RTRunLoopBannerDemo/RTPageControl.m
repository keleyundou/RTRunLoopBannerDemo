//
//  RTPageControl.m
//  RTRunLoopBannerDemo
//
//  Created by ColaBean on 2017/6/21.
//  Copyright © 2017年 ColaBean. All rights reserved.
//

#import "RTPageControl.h"

#define dotW 6
#define magrin 16

@implementation RTPageControl

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGSize aSize = [self sizeForNumberOfPages:self.numberOfPages];
//    //计算圆点间距
//    CGFloat marginX = dotW + magrin;
//    
//    //计算整个pageControll的宽度
//    CGFloat newW = (self.subviews.count) * marginX - magrin;
//    
//    //设置新frame
//    self.frame = CGRectMake(SCREEN_WIDTH-newW-10, self.frame.origin.y, newW, self.frame.size.height);
//    
//    //设置居中
////        CGPoint center = self.center;
////        center.x = self.superview.center.x;
////        self.center = center;
//    
//    //遍历subview,设置圆点frame
//    for (int i=0; i<[self.subviews count]; i++) {
//        UIImageView* dot = [self.subviews objectAtIndex:i];
//        
//        if (i == self.currentPage) {
//            [dot setFrame:CGRectMake(0 + i * marginX, dot.frame.origin.y, dotW, dotW)];
//        }else {
//            [dot setFrame:CGRectMake(0 + i * marginX, dot.frame.origin.y, dotW, dotW)];
//        }
//    }
}

- (CGFloat)widthForPageControl {
    return (self.subviews.count) * (dotW + magrin) - magrin;
}

- (void)setFrame:(CGRect)frame {
    
    //计算圆点间距
    CGFloat marginX = dotW + magrin;
    
    //计算整个pageControll的宽度
    CGFloat newW = [self widthForPageControl];//(self.subviews.count) * marginX - magrin;
    
    //设置新frame
    frame = CGRectMake(frame.origin.x, frame.origin.y, newW, frame.size.height);
    
    //设置居中
    //        CGPoint center = self.center;
    //        center.x = self.superview.center.x;
    //        self.center = center;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(0 + i * marginX, dot.frame.origin.y, dotW, dotW)];
        }else {
            [dot setFrame:CGRectMake(0 + i * marginX, dot.frame.origin.y, dotW, dotW)];
        }
    }
    [super setFrame:frame];
}
@end
