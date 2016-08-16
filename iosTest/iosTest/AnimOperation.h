//
//  AnimOperation.h
//  iosTest
//
//  Created by fengei on 16/7/29.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresentView.h"
#import "GifModel.h"

@interface AnimOperation : NSOperation

@property (nonatomic,strong)PresentView *presentView;
@property (nonatomic,strong)UIView *listView;
@property (nonatomic,strong) GifModel *model;
@property (nonatomic,assign) NSInteger index;
@end
