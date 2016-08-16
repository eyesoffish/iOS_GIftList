//
//  UIImage+Image.m
//  ZL映客
//
//  Created by fengei on 16/8/3.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+ (UIImage *)imageWithOriginalRenderingModel:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
