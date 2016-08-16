//
//  ShakeLabel.h
//  iosTest
//
//  Created by fengei on 16/7/28.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeLabel : UILabel

//动画时间
@property (nonatomic,assign) NSTimeInterval duration;
//描边的颜色
@property (nonatomic,strong) UIColor *borderColor;

- (void) startAnimaWithDuration:(NSTimeInterval) duration;
@end
