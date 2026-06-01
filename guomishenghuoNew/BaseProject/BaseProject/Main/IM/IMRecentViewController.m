//
//  IMRecentViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/30.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IMRecentViewController.h"
#import "IMChatViewController.h"
#import "LCNetworkManager.h"

@interface IMRecentViewController () <RCIMUserInfoDataSource>

@end

@implementation IMRecentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
//    [self setValue:[UIView new] forKeyPath:@"tableView.tableFooterView"];
    self.conversationListTableView.tableFooterView = [UIView new];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:
     @[
       @(ConversationType_PRIVATE),
       //       @(ConversationType_DISCUSSION),
       //       @(ConversationType_CHATROOM),
       //       @(ConversationType_GROUP),
       //       @(ConversationType_APPSERVICE),
       //       @(ConversationType_SYSTEM)
       ]
     ];
    //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                          @(ConversationType_GROUP)]];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    [[LCNetworkManager sharedManager]
     requestWithURL:kLoginService
     function:@"GetUserMessage"
     params:@{@"id" : userId,}
     success:^(id responseData) {
         
         RCUserInfo *user = [[RCUserInfo alloc] init];
         user.userId = userId;
         user.name = responseData[@"Name"];
         NSString *photo = responseData[@"PhotoPath"];
         if (![photo hasPrefix:@"http"]) {
             photo = [@"http://121.40.189.165/" stringByAppendingString:photo];
         }
         user.portraitUri = photo;
         completion(user);
     } failure:^(NSError *error) {
         NSLog(@"%@", error.localizedDescription);
//         [SVProgressHUD showErrorWithStatus:error.domain];
     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [self refreshConversationTableViewIfNeeded];
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
//    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
////    conversationVC.navigationController.navigationBarHidden = NO;
//    conversationVC.conversationType = model.conversationType;
//    conversationVC.targetId = model.targetId;
//    conversationVC.title = model.conversationTitle;
//    [self.navigationController pushViewController:conversationVC animated:YES];
    
    IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
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
