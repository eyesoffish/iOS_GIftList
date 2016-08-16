//
//  UIBarButtonItem+Item.h
//  ZL映客
//
//  Created by fengei on 16/8/3.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

//高亮
+ (instancetype) itemWithIamge:(UIImage *) image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
//选中
+ (instancetype) iteWithImage:(UIImage *) image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;
@end
