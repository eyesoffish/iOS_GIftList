//
//  PresentView.m
//  iosTest
//
//  Created by fengei on 16/7/28.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "PresentView.h"

@interface PresentView ()

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) void(^completeBlock)(BOOL finished);
@end

@implementation PresentView
- (void)animateWithCompleteBlock:(completeBlock)completed
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(fire) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }];
    self.completeBlock = completed;
}

- (void) fire
{
    _animCount ++;
    if(_animCount == _giftCount)
    {
        [_timer invalidate];
        _timer = nil;
        [UIView animateWithDuration:0.35 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self reset];
            _finished = finished;
            self.completeBlock(finished);
            [self removeFromSuperview];
        }];
    }
    self.skLabel.text = [NSString stringWithFormat:@"X %ld",_animCount];
    [self.skLabel startAnimaWithDuration:0.25];
}
- (void) reset
{
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
    self.skLabel.text = @"";
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
        _originFrame = self.frame;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [UIColor brownColor].CGColor;
    _headImageView.layer.cornerRadius = CGRectGetHeight(_headImageView.frame) / 2;
    _headImageView.layer.masksToBounds = YES;//允许剪裁
    
    _giftImageView.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, CGRectGetHeight(self.frame)-50, 50, 50);
    _nameLabel.frame = CGRectMake(CGRectGetWidth(_headImageView.frame)+5, 5, CGRectGetWidth(_headImageView.frame)*3, 10);
    _giftLabel.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_headImageView.frame)-10-5, CGRectGetWidth(_nameLabel.frame), 10);
    _bgImageView.frame = self.bounds;
    _bgImageView.layer.cornerRadius = self.frame.size.height/2;
    _bgImageView.layer.masksToBounds = YES;
    _skLabel.frame = CGRectMake(CGRectGetMaxX(self.frame)+5, -20, 50, 30);
}
- (void) setUI
{
    _bgImageView = [[UIImageView alloc]init];
    _bgImageView.backgroundColor = [UIColor blackColor];
    _bgImageView.alpha = 0.3;
    _headImageView = [[UIImageView alloc]init];
    _giftImageView = [[UIImageView alloc]init];
    _nameLabel = [[UILabel alloc] init];
    _giftLabel = [[UILabel alloc]init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _giftLabel.textColor = [UIColor yellowColor];
    _giftLabel.font = [UIFont systemFontOfSize:13];
    //初始化动画label
    _skLabel = [[ShakeLabel alloc]init];
    _skLabel.font = [UIFont systemFontOfSize:16];
    _skLabel.borderColor = [UIColor yellowColor];
    _skLabel.textColor = [UIColor greenColor];
    _skLabel.textAlignment = NSTextAlignmentCenter;
    _animCount = 0;
    
    [self addSubview:_bgImageView];
    [self addSubview:_headImageView];
    [self addSubview:_giftImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_giftLabel];
    [self addSubview:_skLabel];
}
- (void)setModel:(GifModel *)model
{
    _model = model;
    _headImageView.image = model.headImage;
    _giftImageView.image = model.giftImage;
    _nameLabel.text = model.name;
    _giftLabel.text = model.giftName;
    _giftCount = model.giftCount;
}
@end
