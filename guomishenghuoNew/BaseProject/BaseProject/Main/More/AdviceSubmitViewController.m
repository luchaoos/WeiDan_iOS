//
//  AdviceSubmitViewController.m
//  LikeAttention
//
//  Created by 于金祥 on 15/8/28.
//  Copyright (c) 2015年 zykj.LikeAttention. All rights reserved.
//

#import "AdviceSubmitViewController.h"
//#import "DataProvider.h"
#import "AppDelegate.h"

@interface AdviceSubmitViewController () <UITextViewDelegate>

@property (nonatomic, strong) UILabel * text_place;

@end

@implementation AdviceSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    _lblTitle.text=@"意见反馈";
    _txt_advicetext.delegate = self;
    _lblRight.font = [UIFont systemFontOfSize:18];
    [self addRightbuttontitle:@"发送"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.text_place = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _txt_advicetext.frame.size.width - 40, 36)];
//    self.text_place.backgroundColor = [UIColor orangeColor];
    self.text_place.text = @"请填写意见反馈的内容";
    self.text_place.alpha = 0.5;
    self.text_place.textColor = [UIColor grayColor];
    [_txt_advicetext addSubview:self.text_place];
    
    _txt_advicetext.delegate = self;
    _txt_advicetext.font = [UIFont systemFontOfSize:20];
}

-(void)clickRightButton:(UIButton *)sender
{
    NSUserDefaults * userdefault=[NSUserDefaults standardUserDefaults];
    if (_txt_advicetext.text.length>0) {
        
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否提交意见" preferredStyle:(UIAlertControllerStyleAlert)];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        UIAlertAction * action_ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
//            DataProvider * dataprovider=[[DataProvider alloc] init];
//            [dataprovider setDelegateObject:self setBackFunctionName:@"submitBackCall:"];
//            [dataprovider FeedBack:[userdefault objectForKey:@"id"] andcontenttext:_txt_advicetext.text];
            
        }];
        
        UIAlertAction * action_cancal = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action_cancal];
        [alert addAction:action_ok];

    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"  提示" message:@"意见反馈内容不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
    }
}
-(void)submitBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"status"][@"succeed"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:@"反馈提交成功" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"status"][@"errdesc"] maskType:(SVProgressHUDMaskTypeBlack)];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_txt_advicetext resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - textView的代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.text_place.hidden = YES;
    
    return YES;
}

@end
