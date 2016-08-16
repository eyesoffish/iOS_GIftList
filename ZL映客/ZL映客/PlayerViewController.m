//
//  PlayerViewController.m
//  ZL映客
//
//  Created by fengei on 16/8/4.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "PlayerViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UIImageView+WebCache.h"
#import "DMHeartFlyView.h"
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@interface PlayerViewController ()

@property (atomic,retain) id <IJKMediaPlayback> player;
@property (atomic,strong) NSURL *url;
@property (weak,nonatomic) UIView *playerView;
@property (nonatomic,strong) UIImageView *dimImage;
@property (nonatomic,assign) NSInteger number;//判断按钮

@property (nonatomic,weak) CALayer *fireworksL;
@property (nonatomic,strong) NSMutableArray *fireworksArray;

@property (nonatomic,assign) CGFloat heartSize;//心大小
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 播放视频
    [self goPlaying];
    
    // 开启通知
    [self installMovieNotificationObservers];
    
    // 设置加载视图
    [self setupLoadingView];
    
    // 创建按钮
    [self setupBtn];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![self.player isPlaying])
    {
        //准备播放
        [self.player prepareToPlay];
    }
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
//播放视频
- (void) goPlaying
{
    self.url = [NSURL URLWithString:_liveUrl];
    _player = [[IJKFFMoviePlayerController alloc]initWithContentURL:self.url withOptions:nil];
    UIView *playerView = [self.player view];
    UIView *displayView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.playerView = displayView;
    [self.view addSubview:self.playerView];
    
    //调整自己的宽度和高度
    playerView.frame = self.playerView.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.playerView insertSubview:playerView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
}

//设置加载视图
- (void) setupLoadingView
{
    self.dimImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [_dimImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",_imgUrl]] placeholderImage:[UIImage imageNamed:@"default_room"]];
    //增加一个模糊的遮罩
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffectView.frame = _dimImage.bounds;
    [_dimImage addSubview:visualEffectView];
    [self.view addSubview:_dimImage];
}
//创建按钮
- (void) setupBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 64 / 2 - 8, 33, 33);
    [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOffset = CGSizeMake(0, 0);
    btn.layer.shadowOpacity = 0.5;
    btn.layer.shadowRadius = 1;
    [btn addTarget:self action:@selector(myGoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //暂停
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(XJScreenW - 33 - 10, 64/2-8, 33, 33);
    if(self.number == 0)
    {
        [playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateSelected];
    }
    else
    {
        [playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
    }
    
    [playBtn addTarget:self action:@selector(play_btn:) forControlEvents:UIControlEventTouchUpInside];
    playBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    playBtn.layer.shadowOffset = CGSizeMake(0, 0);
    playBtn.layer.shadowOpacity = 0.5;
    playBtn.layer.shadowRadius = 1;
    [self.view addSubview:playBtn];
    
    //点赞
    UIButton *hearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hearBtn.frame = CGRectMake(36, XJScreenH-36-10, 36, 36);
    [hearBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    hearBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    hearBtn.layer.shadowOffset = CGSizeMake(0, 0);
    hearBtn.layer.shadowOpacity = 0.5;
    hearBtn.layer.shadowRadius = 1;
    hearBtn.adjustsImageWhenHighlighted = YES;
    [hearBtn addTarget:self action:@selector(hearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hearBtn];
    
    // 礼物
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    giftBtn.frame = CGRectMake(XJScreenW - 50, XJScreenH - 36 -10, 36, 36);
    [giftBtn setImage:[UIImage imageNamed:@"gift"] forState:UIControlStateNormal];
    [giftBtn addTarget:self action:@selector(giftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    giftBtn.layer.shadowOffset = CGSizeMake(0, 0);
    giftBtn.layer.shadowOpacity = 0.5;
    giftBtn.layer.shadowRadius = 1;
    [self.view addSubview:giftBtn];
}
- (void) hearBtnClick:(UIButton *) sender
{
    _heartSize = 36;
    
    DMHeartFlyView *hear = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:hear];
    CGPoint fountainSource = CGPointMake(_heartSize + _heartSize / 2.0, self.view.frame.size.height - _heartSize / 2.0 - 10);
    hear.center = fountainSource;
    [hear animateInView:self.view];
    
    //button点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@1,@0.7,@0.5,@0.3,@0.5,@0.7,@1.0,@1.2,@1.4,@1.2,@1.0];
    btnAnimation.keyTimes = @[@0.0,@0.1,@0.2,@0.3,@0.4,@0.5,@0.6,@0.7,@0.8,@0.9,@1.0];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    [sender.layer addAnimation:btnAnimation forKey:@"SHOW"];
}
- (void) giftBtnClick
{
    CGFloat duraTime = 3.0;
    UIImageView *porsche = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"porsche"]];
    //设置汽车的初始位置
    porsche.frame = CGRectMake(0, 0, 0, 0);
    [self.view addSubview:porsche];
    
    //给汽车添加动画
    [UIView animateWithDuration:duraTime animations:^{
        porsche.frame = CGRectMake(XJScreenW * 0.5-100, XJScreenH * 0.5 -100, 240, 120);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duraTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            porsche.alpha = 0;
        } completion:^(BOOL finished) {
            [porsche removeFromSuperview];
        }];
    });
    
    //烟花
    CALayer *fireworksL = [CALayer layer];
    fireworksL.frame = CGRectMake((XJScreenW-250)*0.5, 100, 250, 50);
    fireworksL.contents = (id)[UIImage imageNamed:@"gift_fireworks_0"].CGImage;
    [self.view.layer addSublayer:fireworksL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duraTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
//            fireworksL.opacity = 0;
        } completion:^(BOOL finished) {
            [fireworksL removeFromSuperlayer];
        }];
    });
    _fireworksL = fireworksL;
    NSMutableArray *tempArray = [NSMutableArray array];
    for(int i=1;i<3;i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gift_fireworks_%d",i]];
        [tempArray addObject:image];
    }
    _fireworksArray = tempArray;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}
static int _fishIndex=0;
- (void) update
{
    _fishIndex++;
    if(_fishIndex>1)
    {
        _fishIndex = 0;
    }
    UIImage *image = self.fireworksArray[_fishIndex];
    _fireworksL.contents = (id)image.CGImage;
}
- (void) play_btn:(UIButton *) sender
{
    sender.selected = !sender.selected;
    if(![self.player isPlaying])
    {
        [self.player play];
    }
    else
    {
        [self.player pause];
    }
}
- (void) myGoBack
{
    //停止播放
    [self.player shutdown];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//开启通知
- (void) installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreparedToPlayDidChange:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}
- (void) removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}
#pragma mark --Selector func
- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}
- (void) loadStateDidChange:(NSNotification *) notification
{
    IJKMPMovieLoadState loadState = _player.loadState;
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    _dimImage.hidden = YES;
    
    switch (_player.playbackState) {
            
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}


@end
