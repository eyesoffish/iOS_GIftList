//
//  MainNavigationController.m
//  ZL映客
//
//  Created by fengei on 16/8/3.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "MainNavigationController.h"

@implementation MainNavigationController

//设置navigation背景
+ (void)initialize
{
    if (self == [MainNavigationController class]) {
        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
        [bar setBackgroundImage:[UIImage imageNamed:@"global_background"] forBarMetrics:UIBarMetricsDefault];
    }
}
@end
