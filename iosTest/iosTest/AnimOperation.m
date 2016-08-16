//
//  AnimOperation.m
//  iosTest
//
//  Created by fengei on 16/7/29.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "AnimOperation.h"

@interface AnimOperation ()

@property (nonatomic,getter=isFinished) BOOL finished;
@property (nonatomic,getter=isExecuting) BOOL executing;
@end


@implementation AnimOperation
@synthesize finished = _finished;
@synthesize executing = _executing;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished = NO;
    }
    return self;
}
- (void) start
{
    [super start];
    if([self isCancelled])
    {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
        _presentView = [[PresentView alloc]init];
        _presentView.model = _model;
        //i % 2  控制最多允许出现几行
        if(_index % 2)
        {
            _presentView.frame = CGRectMake(-self.listView.frame.size.width / 2, 300, self.listView.frame.size.width / 2 , 40);
        }
        else
        {
            _presentView.frame = CGRectMake(-self.listView.frame.size.width/2, 230, self.listView.frame.size.width / 2, 40);
        }
        _presentView.originFrame = _presentView.frame;
        [self.listView addSubview:_presentView];
        [self.presentView animateWithCompleteBlock:^(BOOL finished) {
            self.finished = finished;
        }];
        
    }];
}
#pragma mark ---手动出发KVO
- (void) setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}
- (void) setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}
@end
