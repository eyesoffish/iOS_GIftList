//
//  UIImage+Image.h
//  ZL映客
//
//  Created by fengei on 16/8/3.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

//加载不要被渲染的图片
+ (UIImage *) imageWithOriginalRenderingModel:(NSString *) imageName;
@end
