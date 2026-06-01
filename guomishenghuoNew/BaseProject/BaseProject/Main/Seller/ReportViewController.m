//
//  ReportViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ReportViewController.h"
#import "JSTextView.h"
#import "BottomView.h"


#import "PanicBuyViewController.h"

@interface ReportViewController ()<BottomViewDelegate>

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawUI];
}

- (void)drawUI{
    self.view.backgroundColor = [UIColor whiteColor];
    CustomLabel *information = [[CustomLabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) withContent:@"    商家信息" font:18.0 andRGBr:121 RGBg:124 RGBb:128 adaptive:NO];
    information.backgroundColor = RGB(232, 238, 241);
    [self.view addSubview:information];
    
    CustomLabel *nameLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:information Direction:@"Y"]+5, 200, 30) withContent:@"    小蓝鲸黄河口主题餐厅" font:16.0 andRGBr:48 RGBg:48 RGBb:51 adaptive:NO];
    [self.view addSubview:nameLabel];
    UILabel *distance = [UILabel new];
    [self.view addSubview:distance];
    distance.text = @"300m";
    distance.textColor = RGB(197, 197, 200);
    distance.font = [UIFont systemFontOfSize:16.0];
    distance.textAlignment = NSTextAlignmentRight;
    [distance makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(80);
        make.height.equalTo(nameLabel);
    }];
    CustomLabel *detailAddress = [[CustomLabel alloc]initWithFrame:CGRectMake(5, [Util ReturnViewFrame:nameLabel Direction:@"Y"], SCREEN_WIDTH-5, 30) withContent:@"  临沂市蓝山区,城北新区梦河路与天津路交汇向南100米左拐" font:15.0 andRGBr:194 RGBg:195 RGBb:197 adaptive:YES];
    [self.view addSubview:detailAddress];
    
    CustomLabel *content = [[CustomLabel alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:detailAddress Direction:@"Y"]+15, SCREEN_WIDTH, 40) withContent:@"    举报内容" font:18.0 andRGBr:121 RGBg:124 RGBb:128 adaptive:NO];
    content.backgroundColor = RGB(232, 238, 241);
    [self.view addSubview:content];
    
    JSTextView *jview = [[JSTextView alloc]initWithFrame:CGRectMake(10, [Util ReturnViewFrame:content Direction:@"Y"]+10, SCREEN_WIDTH-20, 180) size:16.0 numLimit:NO];
    jview.tag = 110;
    jview.backgroundColor = RGB(220, 225, 226);
    [self.view addSubview:jview];
    jview.myPlaceholder=@"请输入您举报的内容...";
    jview.myPlaceholderColor= [UIColor lightGrayColor];
    
    BottomView *bview = [[BottomView alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:jview Direction:@"Y"]+10, SCREEN_WIDTH, SCREEN_HEIGHT-[Util ReturnViewFrame:jview Direction:@"Y"]+10)];
    [self.view addSubview:bview];
    bview.delegate = self;
}
// 提交
- (void)commit{
    PanicBuyViewController *pvc = [[PanicBuyViewController alloc]init];
    [self.navigationController pushViewController:pvc animated:YES];
}
#pragma mark 取消第一响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITextView *view = [self.view viewWithTag:110];
    [view resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
