//
//  LiveViewController.m
//  ZL映客
//
//  Created by fengei on 16/8/3.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "LiveViewController.h"
#import "UIBarButtonItem+Item.h"
#import "AttentionViewController.h"
#import "HotViewController.h"
#import "NewViewController.h"
#import "UIView+XJExtension.h"
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@interface LiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//顶部navigationItem控件
@property (nonatomic,strong) UIScrollView *topView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) BOOL isInitial;
@property (nonatomic,strong) UIView *lineView;//下划线
@property (nonatomic,strong) NSMutableArray *titleButtons;
@property (nonatomic,strong) UIButton *selectButton;
@end
@implementation LiveViewController
- (NSMutableArray *)titleButtons
{
    if(!_titleButtons)
    {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置导航条内容
    [self setupNavgationBar];
    //添加底部内容view
    [self setupBottomContentView];
    //添加所有子控件
    [self setupAllChildViewController];
    //不添加额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置状态栏围白色（还要再infoplisht文件中设置ViewController－base status bar appearance ＝ no）
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    //加载下滑隐藏tabbar功能
    [self followScrollView:self.collectionView];
}
//设置导航条内容
- (void) setupNavgationBar
{
    UIScrollView *topView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
    topView.scrollsToTop = NO;
    _topView = topView;
    //把UIScrollView添加到导航控制器
    [self.navigationItem setTitleView:topView];
    
    //left
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIamge:[UIImage imageNamed:@"card_search"] highImage:[UIImage imageNamed:@"card_search"] target:self action:@selector(search)];
    //right
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIamge:[UIImage imageNamed:@"card_message"] highImage:[UIImage imageNamed:@"card_message"] target:nil action:nil];
}
- (void) search
{
    NSLog(@"search click");
}
//添加底部内容view
- (void) setupBottomContentView
{
    //创建一个流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(XJScreenW, XJScreenH);
    
    //设置水平滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    //创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.scrollsToTop = NO;//点击状态栏反回顶部
    
    //开启分页
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    
    //展示cell
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    //注册cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}
//添加所有子控件
- (void) setupAllChildViewController
{
    //关注
    AttentionViewController *attenVC = [[AttentionViewController alloc]init];
    HotViewController *hotVC = [[HotViewController alloc]init];
    NewViewController *newVC = [[NewViewController alloc]init];
    
    attenVC.title = @"关注";
    hotVC.title = @"热门";
    newVC.title = @"最新";
    
    [self addChildViewController:attenVC];
    [self addChildViewController:hotVC];
    [self addChildViewController:newVC];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_isInitial == NO)
    {
        //添加标题
        [self setupAllTitle];
        _isInitial = YES;
    }
}
- (void) setupAllTitle
{
    NSUInteger count = self.childViewControllers.count;
    CGFloat btnW = 50;
    CGFloat btnX = 40;
    CGFloat btnH = CGRectGetHeight(_topView.frame);
    for(int i = 0;i<count;i++)
    {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
        btnX = i * btnW;
        titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
        //监听点击按钮
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:titleButton];
        if(i==0)
        {
            //添加下滑线
            CGFloat h = 2;
            CGFloat y = 38;
            UIView *lineView = [[UIView alloc]init];
            //位置和尺寸
            lineView.xj_height = h;
            [titleButton.titleLabel sizeToFit];
            lineView.xj_width = titleButton.titleLabel.xj_width;
            lineView.xj_centerX = titleButton.xj_centerX;
            lineView.xj_y = y;
            lineView.backgroundColor = [UIColor whiteColor];
            _lineView = lineView;
            [_topView addSubview:lineView];
            [self titleClick:titleButton];
        }
        [self.titleButtons addObject:titleButton];
    }
}
- (void) titleClick:(UIButton *) sender
{
    NSInteger i = sender.tag;
    //重复点击标题按钮的时候，刷新当前界面
    if(sender == _selectButton)
    {
    
    }
    [self selButton:sender];
    //修改collectionView偏移量
    CGFloat offsetX = i * XJScreenW;
    _collectionView.contentOffset = CGPointMake(offsetX, 0);
}
- (void) selButton:(UIButton *) sender
{
    _selectButton.selected = NO;
    sender.selected = YES;
    
    //移动下划线的位置
    [UIView animateWithDuration:0.25 animations:^{
        _lineView.xj_centerX = sender.xj_centerX;
    }];
}
#pragma mark---delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //移除之前控制器view
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor whiteColor];
    //取出对应的字控制器添加到对应的cell上
    UIViewController *vc = self.childViewControllers[indexPath.row];
    vc.view.frame = CGRectMake(0, 0, XJScreenW, XJScreenH);
    [cell.contentView addSubview:vc.view];
    return cell;
}
@end
