//
//  ViewController.m
//  iosTest
//
//  Created by fengei on 16/7/28.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ViewController.h"
#import "ZLQRCodeController.h"
#import "PresentView.h"
#import "GifModel.h"
#import "AnimOperation.h"
@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *giftArray;
@property (nonatomic,strong) NSOperationQueue *queue1;//全局动画队列
@property (nonatomic,strong) NSOperationQueue *queue2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    NSOperationQueue *queue1 = [[NSOperationQueue alloc]init];
    queue1.maxConcurrentOperationCount = 1;//队列分发
    _queue1 = queue1;
    
    NSOperationQueue *queue2 = [[NSOperationQueue alloc]init];
    queue2.maxConcurrentOperationCount = 1;
    _queue2 = queue2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [ZLQRCodeController scanQRCodeImage:self];
    for(int i=0;i<self.giftArray.count;i++)
    {
        NSLog(@"%@",[self.giftArray[i] name]);
        AnimOperation *op = [[AnimOperation alloc]init];
        op.listView = self.view;
        if(i % 2)
        {
            op.model = self.giftArray[i];
            op.index = i;
            if(op.model.giftCount != 0)
            {
                [_queue1 addOperation:op];
            }
        }
        else
        {
            op.index = i;
            op.model = self.giftArray[i];
            if(op.model.giftCount != 0)
            {
                [_queue2 addOperation:op];
            }
        }
    }
}

#pragma mark --getter
- (NSMutableArray *)giftArray
{
    if(!_giftArray)
    {
        _giftArray = [NSMutableArray array];
        GifModel *model = [[GifModel alloc]init];
        model.headImage = [UIImage imageNamed:@"luffy"];
        model.giftImage = [UIImage imageNamed:@"flower"];
        model.name = @"姑父成";
        model.giftName = @"送了一朵鲜花";
        model.giftCount = 5;
        
        GifModel *model2 = [[GifModel alloc]init];
        model2.headImage = [UIImage imageNamed:@"code"];
        model2.giftImage = [UIImage imageNamed:@"mogu"];
        model2.name = @"卡扎菲";
        model2.giftName = @"送了一朵蘑菇";
        model2.giftCount = 9;
        
        GifModel *model3 = [[GifModel alloc]init];
        model3.headImage = [UIImage imageNamed:@"fang"];
        model3.giftImage = [UIImage imageNamed:@"house"];
        model3.name = @"土豪";
        model3.giftName = @"送了你一栋房子";
        model3.giftCount = 4;
        
        GifModel *model4 = [[GifModel alloc]init];
        model4.headImage = [UIImage imageNamed:@"hashiqi"];
        model4.giftImage = [UIImage imageNamed:@"dogfood"];
        model4.name = @"哈士奇";
        model4.giftName = @"送了一袋狗粮";
        model4.giftCount = 4;
        
        [_giftArray addObject:model];
        [_giftArray addObject:model2];
        [_giftArray addObject:model4];
        [_giftArray addObject:model3];
    }
    return _giftArray;
}
@end
