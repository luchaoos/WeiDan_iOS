//
//  IMFriendInfoViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/31.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IMFriendInfoViewController.h"
#import "LCNetworkManager.h"
#import "IMChatViewController.h"
@interface IMFriendInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIView *btnView;

@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, copy) NSString *jifen;

@end

@implementation IMFriendInfoViewController

- (IBAction)fasongxiaoxi:(id)sender {
    IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
    conversationVC.conversationType = 1;
    conversationVC.targetId = [NSString stringWithFormat:@"%@", self.userInfoDict[@"Id"]];
    if (self.userInfoDict[@"UserId"]) {
        conversationVC.targetId = [NSString stringWithFormat:@"%@", self.userInfoDict[@"UserId"]];
    }
    conversationVC.title = self.userInfoDict[@"Name"];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (IBAction)shanchu:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除该好友" message:@"'" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LCNetworkManager sharedManager]
         requestWithURL:kFriendService
         function:@"DeleteFriend"
         params:@{@"userid" : get_sp(user_ID),
                  @"friendid" : self.userId}
         success:^(id responseData) {
             
             [SVProgressHUD showSuccessWithStatus:@"删除成功"];
             [self.navigationController popViewControllerAnimated:YES];
             
         } failure:^(NSError *error) {
             NSLog(@"%@", error.localizedDescription);
             [SVProgressHUD showErrorWithStatus:error.domain];
         }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)tianjiaORzengsong:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"赠送米币"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"赠送米币" message:@"'" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入米币数量";
            [textField addTarget:self action:@selector(txtChange:) forControlEvents:UIControlEventEditingDidEnd];
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[LCNetworkManager sharedManager]
             requestWithURL:kFriendService
             function:@"PresentPoint"
             params:@{@"userid" : get_sp(user_ID),
                      @"friendid" : self.userId,
                      @"point" : _jifen}
             success:^(id responseData) {
                 
                 [SVProgressHUD showSuccessWithStatus:@"赠送成功"];
                 
             } failure:^(NSError *error) {
                 NSLog(@"%@", error.localizedDescription);
                 [SVProgressHUD showErrorWithStatus:error.domain];
             }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([sender.currentTitle isEqualToString:@"添加好友"]) {
        [SVProgressHUD show];
        [[LCNetworkManager sharedManager]
         requestWithURL:kFriendService
         function:@"SaveFriend"
         params:@{@"userid" : get_sp(user_ID),
                  @"friendid" : self.userInfoDict[@"Id"]}
         success:^(id responseData) {
             [SVProgressHUD dismiss];
             [SVProgressHUD showSuccessWithStatus:@"申请成功"];
             NSLog(@"%@", responseData);
         } failure:^(NSError *error) {
             [SVProgressHUD dismiss];
             NSLog(@"%@", error.localizedDescription);
             [SVProgressHUD showErrorWithStatus:error.domain];
         }];
    }
}

- (void)txtChange:(UITextField *)sender {
    _jifen = sender.text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.text = @"详细资料";
    
//    [self fillData];
    
    [SVProgressHUD show];
    [[LCNetworkManager sharedManager]
     requestWithURL:kLoginService
     function:@"GetUserMessage"
     params:@{@"id" : self.userId,}
     success:^(id responseData) {
         
         RCUserInfo *user = [[RCUserInfo alloc] init];
         user.userId = responseData[@"Id"];
         user.name = responseData[@"Name"];
         NSString *photo = responseData[@"PhotoPath"];
         if (![photo hasPrefix:@"http"]) {
             photo = [@"http://121.40.189.165/" stringByAppendingString:photo];
         }
         user.portraitUri = photo;
         
         self.userInfoDict = [responseData copy];
         
         [[LCNetworkManager sharedManager]
          requestWithURL:kFriendService
          function:@"IsFriends"
          params:@{@"userid" : get_sp(user_ID),
                   @"friendid" : self.userId}
          success:^(id responseData) {
              [SVProgressHUD dismiss];
              self.isFriend = [responseData[@"IsFriend"] boolValue];
              self.isMine = [self.userId integerValue] == [get_sp(user_ID) integerValue];
              [self fillData];
          } failure:^(NSError *error) {
              [SVProgressHUD dismiss];
              NSLog(@"%@", error.localizedDescription);
              [SVProgressHUD showErrorWithStatus:error.domain];
          }];
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
         NSLog(@"%@", error.localizedDescription);
         //         [SVProgressHUD showErrorWithStatus:error.domain];
     }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)fillData {
    NSString *photo = self.userInfoDict[@"PhotoPath"];
    if (![photo hasPrefix:@"http"]) {
        photo = [@"http://121.40.189.165/" stringByAppendingString:photo];
    }
    [self.image sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    
    self.label1.text = [NSString stringWithFormat:@"用户名: %@", self.userInfoDict[@"Name"]];
    self.label2.text = [NSString stringWithFormat:@"ID: %@", self.userInfoDict[@"Id"]];
//    if (self.userInfoDict[@"UserId"]) {
//        self.label2.text = [NSString stringWithFormat:@"ID: %@", self.userInfoDict[@"UserId"]];
//        
//    }
    self.label3.text = [NSString stringWithFormat:@"手机号: %@", self.userInfoDict[@"Phone"]];
    if (self.isFriend) {//[self.userInfoDict[@"IsFriend"] boolValue] == YES) {
        self.btn1.hidden = NO;
        self.btn2.hidden = NO;
        self.btn3.hidden = NO;
        [self.btn3 setTitle:@"赠送米币" forState:UIControlStateNormal];
    } else {
        self.btn1.hidden = YES;
        self.btn2.hidden = YES;
        self.btn3.hidden = NO;
        [self.btn3 setTitle:@"添加好友" forState:UIControlStateNormal];
    }
    if (self.isMine) {
        self.btnView.hidden = YES;
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
