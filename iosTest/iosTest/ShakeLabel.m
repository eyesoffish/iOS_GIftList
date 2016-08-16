//
//  ShakeLabel.m
//  iosTest
//
//  Created by fengei on 16/7/28.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ShakeLabel.h"

@implementation ShakeLabel

- (void) startAnimaWithDuration:(NSTimeInterval) duration
{
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            self.transform = CGAffineTransformMakeScale(4, 4);
        }];//相对于地duration开始的动画时间第0秒开始动
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];//相对于duration开始的动画时间，第duration／2秒开始动画
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }];
}
//重写drawTextInRect 文字描边
- (void) drawTextInRect:(CGRect)rect
{
    CGSize shandowOffest = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(con, 5);//画线
    CGContextSetLineJoin(con, kCGLineJoinRound);//转角样式为圆角
    
    CGContextSetTextDrawingMode(con, kCGTextStroke);//绘制文本的模式。该函数支持kCGTextFill、kCGTextStroke、kCGTextFillStroke等绘制模式。
    self.textColor = _borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(con, kCGTextFill);//设置绘制文本模式
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    self.shadowOffset = shandowOffest;
}
@end
