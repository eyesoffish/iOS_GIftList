//
//  PresentView.h
//  iosTest
//
//  Created by fengei on 16/7/28.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeLabel.h"
#import "GifModel.h"
typedef NS_ENUM(NSInteger,PrensentViewGiftType)
{
    //flowers
    PresentViewGiftTypeFlower,
    //送蘑菇
    PresentViewGiftTypeMogu,
    //送房子
    PresentViewGiftTypeHouse
};
typedef void (^completeBlock)(BOOL finished);
@interface PresentView : UIView

@property (nonatomic,strong) GifModel *model;
@property (nonatomic,strong) UIImageView *headImageView;//头像
@property (nonatomic,strong) UIImageView *giftImageView;//礼物
@property (nonatomic,strong) UILabel *nameLabel;//送礼物者
@property (nonatomic,strong) UILabel *giftLabel;//礼物名称
@property (nonatomic,assign) NSInteger giftCount;//礼物个数

@property (nonatomic,strong) ShakeLabel *skLabel;
@property (nonatomic,assign) NSInteger animCount;//动画执行到底几次
@property (nonatomic,assign) CGRect originFrame;//记录原始坐标
@property (nonatomic,assign) BOOL finished;
- (void) animateWithCompleteBlock:(completeBlock) completed;
@end
