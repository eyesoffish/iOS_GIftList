//
//  MainTabBarController.m
//  ZL映客
//
//  Created by fengei on 16/8/3.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "MainTabBarController.h"
#import "CameraViewController.h"
#import "LiveViewController.h"
#import "MineViewController.h"
#import "UIImage+Image.h"
#import "MainNavigationController.h"
@interface MainTabBarController ()<UITabBarControllerDelegate>

@end
@implementation MainTabBarController

- (void)viewDidLoad
{
    //添加所有的子控制器
    [self setupAllViewController];
    //设置tabbar上面的内容
    [self setupAllTabBarButton];
    //添加视频采集按钮
    [self addCameraButton];
    //设置顶部tabBar背景图片
    [self setupTabBarBackgroundImage];
    //设置代理监听tabBar上的按钮点击
    self.delegate = self;
}
//添加所有的子控制器
- (void) setupAllViewController
{
    //Live
    LiveViewController *liveVC = [[LiveViewController alloc]init];
    CameraViewController *cameraVC = [[CameraViewController alloc]init];
    MineViewController *mineVC = [[MineViewController alloc]init];
    [self addNaviController:liveVC];
    [self addNaviController:cameraVC];
    [self addNaviController:mineVC];
}
- (void) addNaviController:(UIViewController *)control
{
    MainNavigationController *nav = [[MainNavigationController alloc]initWithRootViewController:control];
    [self addChildViewController:nav];
}
//设置tabbar上面的内容
- (void) setupAllTabBarButton
{
    //设置tabBar按钮内容
    LiveViewController *liveVC = self.viewControllers[0];
    liveVC.tabBarItem.image = [UIImage imageNamed:@"tab_live"];
    liveVC.tabBarItem.selectedImage = [UIImage imageWithOriginalRenderingModel:@"tab_live_p"];
    
    CameraViewController *cameraVC = self.viewControllers[1];
    cameraVC.tabBarItem.enabled = NO;
    
    MineViewController *mineVC = self.childViewControllers[2];
    mineVC.tabBarItem.image = [UIImage imageNamed:@"tab_me"];
    mineVC.tabBarItem.selectedImage = [UIImage imageWithOriginalRenderingModel:@"tab_me_p"];
    //调整TabBarItem位置
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 0, -10, 0);
    UIEdgeInsets cameraInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    liveVC.tabBarItem.imageInsets = insets;
    mineVC.tabBarItem.imageInsets = insets;
    cameraVC.tabBarItem.imageInsets = cameraInsets;
    
    //隐藏阴影线
    [[UITabBar appearance]setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
}
//添加视频采集按钮
- (void) addCameraButton
{
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setImage:[UIImage imageNamed:@"tab_room"] forState:UIControlStateNormal];
    [cameraBtn setImage:[UIImage imageNamed:@"tab_room_p"] forState:UIControlStateHighlighted];
    //自适应，自定根据图片和文字计算按钮尺寸
    [cameraBtn sizeToFit];
    cameraBtn.center = CGPointMake(CGRectGetWidth(self.tabBar.frame)*0.5, CGRectGetHeight(self.tabBar.frame)*0.5+5);
    [cameraBtn addTarget:self action:@selector(cameraClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:cameraBtn];
}
//按钮点击事件
- (void) cameraClick
{
//    CameraViewController *cameraVC = [[CameraViewController alloc]init];
//    [self presentViewController:cameraVC animated:YES completion:nil];
}
//设置顶部tabBar背景图片
- (void) setupTabBarBackgroundImage
{
    UIImage *image = [UIImage imageNamed:@"tab_bg"];
    CGFloat top = 40;//顶端盖高度
    CGFloat bottom = 40;//底端盖高度
    CGFloat left = 100;//
    CGFloat right = 100;
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    //指定为拉伸模式，伸缩后重新赋值
    UIImage *tabBgImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.tabBar.backgroundImage = tabBgImage;
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
}
// 自定义tabBar高度
- (void) viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 60;
    tabFrame.origin.y = self.view.frame.size.height - 60;
    self.tabBar.frame = tabFrame;
}
@end
