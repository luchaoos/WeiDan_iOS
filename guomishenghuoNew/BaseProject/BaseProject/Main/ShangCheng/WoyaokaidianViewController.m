//
//  WoyaokaidianViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/6/17.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "WoyaokaidianViewController.h"

@interface WoyaokaidianViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UITextField *txt3;

@end

@implementation WoyaokaidianViewController

- (IBAction)done:(id)sender {
    if (!self.txt1.hasText) {
        return [SVProgressHUD showErrorWithStatus:@"请填写商家名称"];
    }
    if (!self.txt2.hasText) {
        return [SVProgressHUD showErrorWithStatus:@"请填写联系方式"];
    }
    if (!self.txt3.hasText) {
        return [SVProgressHUD showErrorWithStatus:@"请填写商家地址"];
    }
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"commitFinish:" setFailBackFunctionName:nil];
    [dataProvider OtherServiceApplyOpenPointShopNewWithShopid:get_sp(user_ID) ? get_sp(user_ID) : @"0" shopname:_txt1.text phone:_txt2.text address:_txt3.text];
}

- (void)commitFinish:(NSDictionary *)data {
    if (RequestSuccess(data)) {
        [SVProgressHUD showSuccessWithStatus:@"申请成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:data[@"error"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.text = @"商家入驻";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
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
