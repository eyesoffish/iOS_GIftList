//
//  ZLQRCodeController.m
//  MyTwoCodeTest
//
//  Created by fengei on 16/7/6.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ZLQRCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface ZLQRCodeController()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) UIView *scanRectView;
@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preView;
@property (nonatomic,strong) UIWebView *webView;

// 记录向上滑动最小边界
@property (nonatomic,assign) CGFloat minY;
//记录向下滑动的最大边界
@property (nonatomic,assign) CGFloat maxY;
//扫面区域的横线是否应该向上滑动
@property (nonatomic,assign) BOOL shouldUP;
//扫面区域的图片
@property (nonatomic,strong) UIImageView *imageV;
@end
@implementation ZLQRCodeController
+(UIImage *) getQRCodeImageWithString:(NSString *) info imageWidth:(CGFloat) width
{
    return [[ZLQRCodeController shareZLQRCode] creatQrCodeAction:info imageW:width];
}
+ (void) scanQRCodeImage:(UIViewController *) senderControler
{
    [[ZLQRCodeController shareZLQRCode] myScanQRCodeImage:senderControler];
}
+ (ZLQRCodeController *) shareZLQRCode
{
    static ZLQRCodeController *distance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        distance = [[ZLQRCodeController alloc]init];
    });
    return distance;
}
//------------------------------------------------------------//
- (void) myScanQRCodeImage:(UIViewController *)senderControler
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查设备相机" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [senderControler presentViewController:alert animated:YES completion:nil];
        return;
    }
    else
    {
        if(senderControler.navigationController != nil)
        {
            [senderControler.navigationController pushViewController:[ZLQRCodeController shareZLQRCode] animated:YES];
        }
        else
        {
            NSLog(@"======>需要一个 navigationController!!");
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.session startRunning];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick)];
    self.title = @"扫一扫";
    [self sweepView];//开始扫描
}
- (void) btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.session stopRunning];
}
- (void) sweepView
{
    //获取摄像输入设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    self.output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理，在主线程里面刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集
    [self.session setSessionPreset:(CGRectGetHeight(self.view.frame)<500?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh)];
    //链接对象添加输入输出流
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //AVMEtadataMachineReadableCodeObject对象从QR码生成返回这个常数作为她们的类型
    //设置扫码支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code];
    //自定义取景框
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGSize scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
    //开始滑动线条
    [self scanningAnimationWith:scanRect];
    //创建周围模糊区域
    [self getCGRect:scanRect];
    self.minY = CGRectGetMinY(scanRect);
    self.maxY = CGRectGetMaxY(scanRect);
    
    //计算rectOfInterest 注意x,y交换位置
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width,scanRect.size.height/windowSize.height, scanRect.size.width/windowSize.width);
    self.output.rectOfInterest = scanRect;
    
    self.scanRectView = [UIView new];
    [self.view addSubview:self.scanRectView];
    self.scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
    self.scanRectView.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    self.scanRectView.layer.borderWidth = 1;
    //上面设置过一次rectofInterest
    self.preView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preView.frame = self.view.frame;
    [self.view.layer insertSublayer:self.preView atIndex:0];
}
- (void) getCGRect:(CGRect) rect
{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    CGFloat w = CGRectGetWidth(rect);
    CGFloat h = CGRectGetHeight(rect);
    [self createFuzzyViewWith:CGRectMake(0, 0, width, y)];
    [self createFuzzyViewWith:CGRectMake(0, y, x, h)];
    [self createFuzzyViewWith:CGRectMake(x+w, y, width-x-w, h)];
    [self createFuzzyViewWith:CGRectMake(0, y+h, width, height)];
}
- (void) createFuzzyViewWith:(CGRect) rect
{
    UIView *tempView = [[UIView alloc]initWithFrame:rect];
    tempView.backgroundColor = [UIColor blackColor];
    tempView.alpha = 0.4;
    [self.view addSubview:tempView];
}
- (void) scanningAnimationWith:(CGRect) rect
{
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, 3)];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"scanLine" ofType:@"png"];
    self.shouldUP = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];
    self.imageV.image = [UIImage imageWithContentsOfFile:imagePath];
    [self.view addSubview:self.imageV];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y+height, width, 30)];
    label.text = @"请将扫面区域对准二维码";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
}
- (void) repeatAction
{
    CGFloat num = 1;
    if(self.shouldUP == NO)
    {
        self.imageV.frame = CGRectMake(CGRectGetMinX(self.imageV.frame), CGRectGetMinY(self.imageV.frame)+num, CGRectGetWidth(self.imageV.frame), CGRectGetHeight(self.imageV.frame));
        if(CGRectGetMaxY(self.imageV.frame) >= self.maxY)
        {
            self.shouldUP = YES;
        }
    }
    else
    {
        self.imageV.frame = CGRectMake(CGRectGetMinX(self.imageV.frame), CGRectGetMinY(self.imageV.frame)-num, CGRectGetWidth(self.imageV.frame), CGRectGetHeight(self.imageV.frame));
        if(CGRectGetMaxY(self.imageV.frame) <= self.minY)
        {
            self.shouldUP = NO;
        }
    }
}
#pragma mark ----metadataDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //系统处于铃声模式下扫描到结果会调用咔嚓的声音
    AudioServicesPlaySystemSound(1305);
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //没有捕捉到信息
    if(metadataObjects.count == 0)
    {
        return;
    }
    //捕捉并成功保存二维码
    if(metadataObjects.count > 0)
    {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *currentMetadataObject = metadataObjects.firstObject;
        //扫描出字符串
        NSString *res = currentMetadataObject.stringValue;
        NSLog(@"二维码扫描结果 %@",res);
        if(self.resBack)
        {
            self.resBack(res);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (UIImage *)creatQrCodeAction:(NSString *) senderString imageW:(CGFloat ) width{
    if(width <= 0)
    {
        width = 100;
    }
    ///生成二维码,原生态生成二维码需要导入CoreImage.framework
    //二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    //字符串转换为data
    NSData *data = [senderString dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    //获得滤镜输出的图像
    CIImage *outPutImage = [filter outputImage];
    //将CIImage转换成UImage并展示
    UIImage *image =  [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:width];
    return image;
}
///将数据转换为二维码图片
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
