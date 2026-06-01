//
//  TuiguangViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/6/2.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "TuiguangViewController.h"
#import "TuiguangSub1ViewController.h"
#import "TuiguangSub2ViewController.h"
#import "TixianViewController.h"
#import "BangdingyinhangkaViewController.h"

@interface TuiguangViewController ()

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;



@end

@implementation TuiguangViewController

- (IBAction)toSub1:(id)sender {
    [self.navigationController pushViewController:[[TuiguangSub1ViewController alloc] init] animated:YES];
}

- (IBAction)tuSub2:(id)sender {
    [self.navigationController pushViewController:[[TuiguangSub2ViewController alloc] init] animated:YES];
}

- (IBAction)tixian:(id)sender {
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"isBindBankCardFinish:" setFailBackFunctionName:nil];
    [dataProvider commissionServiceIsBindBankCardWithShopid:get_sp(user_ID)];
    
    
}

- (void)isBindBankCardFinish:(NSDictionary *)data {
//    return [self.navigationController pushViewController:[[BangdingyinhangkaViewController alloc] init] animated:YES];
    
    
    if ([data[@"data"][@"IsBindBankCard"] integerValue] == 0) {
        [self.navigationController pushViewController:[[BangdingyinhangkaViewController alloc] init] animated:YES];
    } else {
        TixianViewController *vc = [[TixianViewController alloc] init];
        vc.backNo = data[@"data"][@"CardNo"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _imgLeft.hidden=YES;
    _lblTitle.text=@"推广";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.codeLabel.text = [NSString stringWithFormat:@"我的分销码：100%@", get_sp(user_ID)];
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSString *dataString =
    [NSString stringWithFormat:@"http://121.40.189.165/7777/GoIn.aspx?ma=100%@", get_sp(user_ID)];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    self.codeImage.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:_codeImage.mj_w];
}

- (void)viewWillAppear:(BOOL)animated {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];

    [super viewWillAppear:animated];
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getDataFinish:" setFailBackFunctionName:nil];
    [dataProvider shopIndexServiceGetDistributionWithShopid:get_sp(user_ID)];
}


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


- (void)getDataFinish:(NSDictionary *)data {
    NSLog(@"%@", data);
    if (RequestSuccess(data)) {
        NSDictionary *tdata = data[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.label1.text = [NSString stringWithFormat:@"￥%.2lf", [tdata[@"TotalCommission"] doubleValue]];
            self.label2.text = [NSString stringWithFormat:@"￥%.2lf", [tdata[@"AllCommission"] doubleValue]];
            self.label3.text = [NSString stringWithFormat:@"%lld人",[tdata[@"SubordinateNum"] longLongValue]];
            self.label4.text = [NSString stringWithFormat:@"%.2lf元", [tdata[@"AllCommission"] doubleValue]];
            
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
