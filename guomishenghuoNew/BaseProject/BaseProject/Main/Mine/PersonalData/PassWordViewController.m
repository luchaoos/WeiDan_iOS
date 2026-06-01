//
//  PassWordViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PassWordViewController.h"

@interface PassWordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *word1;
@property (weak, nonatomic) IBOutlet UITextField *word2;

@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)commitClick:(id)sender {
    
    if ([_oldPassword.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入旧密码！"];
        return;
    }
    if ([_word1.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码！"];
        return;
    }
    if ([_word2.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码！"];
        return;
    }
    if (![_word1.text isEqualToString:_word2.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致！"];
        return;
    }
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"changePasswordCallBack:" setFailBackFunctionName:nil];
//    NSLog(@"%@",[Toolkit getUserDefaultByKey:user_ID]);
    [dataProvider changePasswordWithId:[Toolkit getUserDefaultByKey:user_ID] oldpassword:_oldPassword.text newpassword:_word1.text];
}
-(void)changePasswordCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"message"]];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_word1 resignFirstResponder];
    [_word2 resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
