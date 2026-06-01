//
//  IMChatViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/31.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IMChatViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "IMFriendInfoViewController.h"

@interface IMChatViewController ()

@end

@implementation IMChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didTapCellPortrait:(NSString *)userId {
    NSLog(@"%@", userId);
    IMFriendInfoViewController *vc = [[IMFriendInfoViewController alloc] init];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [_app_ hiddenTabBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
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
