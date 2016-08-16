//
//  HotViewController.m
//  ZL映客
//
//  Created by fengei on 16/8/4.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "HotViewController.h"
#import "ODRefreshControl/ODRefreshControl.h"
#import "NetWorkEngine/NetWorkEngine.h"
#import "PlayerModel.h"
#import "PlayerTableViewCell.h"
#import "PlayerViewController.h"
// 映客接口
#define MainData [NSString stringWithFormat:@"http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1"]
#define Ratio 618/480
@interface HotViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableView
    [self setupTableView];
    //添加下拉刷新
    [self addRefresh];
    //加载数据
    [self loadData];
}

//初始化tableView
- (void) setupTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = [UIScreen mainScreen].bounds.size.width * Ratio + 1;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
//添加下拉刷新
- (void) addRefresh
{
    ODRefreshControl *refreshController = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    [refreshController addTarget:self action:@selector(dropViewDidBeginRefresh:) forControlEvents:UIControlEventValueChanged];
    
}
- (void) dropViewDidBeginRefresh:(ODRefreshControl *) refrshControl
{
    double delayInsecinds = 3.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInsecinds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refrshControl endRefreshing];
        [self loadData];
    });
}
//加载数据
- (void) loadData
{
    [self.dataArray removeAllObjects];
    __weak HotViewController *vc = self;
    NetWorkEngine *newWork = [[NetWorkEngine alloc]init];
    [newWork AfJSONGetRequest:MainData];
    newWork.successfulBlock = ^(id object){
        NSArray *listArray = [object objectForKey:@"lives"];
        for(NSDictionary *dic in listArray)
        {
            PlayerModel *model = [[PlayerModel alloc]initWithDic:dic];
            model.city = dic[@"city"];
            model.portrait = dic[@"creator"][@"portrait"];
            model.name = dic[@"creator"][@"name"];
            model.online_users = [dic[@"online_users"] intValue];
            model.url = dic[@"stream_addr"];
            [vc.dataArray addObject:model];
        }
        [self.tableView reloadData];
    };
}
#pragma mark ---tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[PlayerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PlayerModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewController *playerVC = [[PlayerViewController alloc]init];
    PlayerModel *model = self.dataArray[indexPath.row];
    //直播url
    playerVC.liveUrl = model.url;
    //直播图片
    playerVC.imgUrl = model.portrait;
    [self.navigationController pushViewController:playerVC animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark --getter
- (NSMutableArray *)dataArray{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
