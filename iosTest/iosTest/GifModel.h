//
//  GifModel.h
//  iosTest
//
//  Created by fengei on 16/7/28.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GifModel : NSObject

@property (nonatomic,strong) UIImage *headImage;//头像
@property (nonatomic,strong) UIImage *giftImage;//礼物
@property (nonatomic,strong) NSString *name;//送礼物者
@property (nonatomic,strong) NSString *giftName;// 礼物的名字
@property (nonatomic,assign) NSInteger giftCount;//礼物的个数

@end
