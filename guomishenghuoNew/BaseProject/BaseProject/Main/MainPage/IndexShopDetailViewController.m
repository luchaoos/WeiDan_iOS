//
//  IndexShopDetailViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/8/11.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IndexShopDetailViewController.h"
#import "LCNetworkManager.h"
#import "IndexShopDetailCell.h"
#import "CWStarRateView.h"
#import "PayInShopViewController.h"
#import "PingLunViewController.h"
#import "JXMapNavigationView.h"
#import "PhotoLibraryViewController.h"

@interface IndexShopDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary *infoData;
@property (nonatomic, strong) NSArray *otherShopList;
@property (nonatomic, assign) CGFloat webViewH;

@end

@implementation IndexShopDetailViewController
static NSString *cellIdTop = @"cellIdTop";
static NSString *cellIdWeb = @"cellIdWeb";
static NSString *cellIdCmt = @"cellIdCmt";
static NSString *cellIdOther = @"cellIdOther";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [UIView new];
    //    self.tableView.sectionHeaderHeight = 1.f;
    //    self.tableView.sectionFooterHeight = 1.f;
    
    self.infoData = @{};
    self.otherShopList = @[];
    
    [[LCNetworkManager sharedManager]
     requestWithURL:@"HomeService.asmx/Entry"
     function:@"GetShopMessage"
     params:@{@"shopid" : self.shopId,
              @"buyerid" : get_sp(user_ID)}
     success:^(id responseData) {
         NSLog(@"%@", responseData);
         self.infoData = responseData[@"result1"];
         _lblTitle.text = self.infoData[@"Name"];
         self.otherShopList = responseData[@"result2"];
         [self.tableView reloadData];
     } failure:^(NSError *error) {
         NSLog(@"%@", error.localizedDescription);
         [SVProgressHUD showErrorWithStatus:error.domain];
     }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.otherShopList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        IndexShopDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdTop];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"IndexShopDetailCell" owner:nil options:nil][0];
            [cell setValue:cellIdTop forKey:@"reuseIdentifier"];
        }
        [cell.topImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.40.189.165/%@", self.infoData[@"PhotoPath"]]] placeholderImage:[UIImage imageNamed:@""]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.infoData[@"Name"]];
        cell.scoreLabel.text = [NSString stringWithFormat:@"5.0分"];
        cell.starView.scorePercent = 1;
        cell.addressLabel.text = [NSString stringWithFormat:@"%@", self.infoData[@"Address"]];
        MJWeakSelf
        cell.payInShopBlock = ^{
            PayInShopViewController * payInShopVC=[[PayInShopViewController alloc] init];
            payInShopVC.shopID = weakSelf.infoData[@"Id"];
            payInShopVC.fandian = [weakSelf.infoData[@"JifenRate"] floatValue];
            [weakSelf.navigationController pushViewController:payInShopVC animated:YES];
        };
        cell.callBlock = ^{
            [Toolkit makeCall:[NSString stringWithFormat:@"%@", self.infoData[@"Phone"]]];
        };
        cell.navBlock = ^{
            JXMapNavigationView * mapNavigationView = [[JXMapNavigationView alloc]init];
            [mapNavigationView showMapNavigationViewWithtargetLatitude:[weakSelf.infoData[@"Lat"] floatValue] targetLongitute:[weakSelf.infoData[@"Lng"] floatValue] toName:weakSelf.infoData[@"Name"]];
            [weakSelf.view addSubview:mapNavigationView];
        };
        cell.photosBlock = ^{
            PhotoLibraryViewController * photoLibraryVC=[[PhotoLibraryViewController alloc] init];
            photoLibraryVC.shopID = weakSelf.infoData[@"Id"];
            [weakSelf.navigationController pushViewController:photoLibraryVC animated:YES];
        };
        return cell;
    }
    else if (indexPath.section == 1) {
        
        IndexShopDetailWebCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdWeb];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"IndexShopDetailCell" owner:nil options:nil][1];
            [cell setValue:cellIdWeb forKey:@"reuseIdentifier"];
            cell.webView.dataDetectorTypes = UIDataDetectorTypeNone;
            cell.webView.scrollView.bounces = NO;
            cell.webView.scrollView.showsVerticalScrollIndicator = NO;
            cell.webView.scrollView.showsHorizontalScrollIndicator = NO;
            cell.webView.delegate = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSMutableString *HTML = @"".mutableCopy;
                [HTML appendString:@"<html>"];
                [HTML appendString:@"<head><style type=\"text/css\">img{width:100% !important;}</style>"];
                [HTML appendString:@"<body>"];
                [HTML appendString:[NSString stringWithFormat:@"%@", self.infoData[@"Content"]]];
                [HTML appendString:@"</body>"];
                [HTML appendString:@"</html>"];
                [cell.webView loadHTMLString:HTML baseURL:[NSURL URLWithString:@"http://121.40.189.165/"]];
            });
        }
        
        return cell;
    }
    else if (indexPath.section == 2) {
        IndexShopDetailCmtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdCmt];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"IndexShopDetailCell" owner:nil options:nil][2];
            [cell setValue:cellIdCmt forKey:@"reuseIdentifier"];
        }
        cell.scoreLabel.text = @"5.0分";
        cell.cmtNumLabel.text = @"";
        return cell;
    }
    else if (indexPath.section == 3) {
        IndexShopDetailOtherShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdOther];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"IndexShopDetailCell" owner:nil options:nil][3];
            [cell setValue:cellIdOther forKey:@"reuseIdentifier"];
        }
        NSDictionary *dict = self.otherShopList[indexPath.row];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.40.189.165/%@", dict[@"PhotoPath"]]] placeholderImage:[UIImage imageNamed:@""]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", dict[@"Name"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"人均%@元", dict[@"RenJun"]];
        cell.otherLabel.text = [NSString stringWithFormat:@"满100减%@", dict[@"JifenRate"]];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView sizeToFit];
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    if (self.webViewH != height)
    {
        self.webViewH = height;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 340 * SCREEN_WIDTH / 375;
    }
    else if (indexPath.section == 1) {
        return self.webViewH;//200;
    }
    else if (indexPath.section == 2) {
        return 71;
    }
    else if (indexPath.section == 3) {
        return 80;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    }
    else if (section == 1) {
        return @"店铺详情";
    }
    else if (section == 2) {
        return @"店铺评价";
    }
    else if (section == 3) {
        return @"推荐商家";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return 30;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        PingLunViewController * pinglunVC=[[PingLunViewController alloc] init];
        pinglunVC.shopid = self.infoData[@"Id"];
        pinglunVC.type = @"1";
        [self.navigationController pushViewController:pinglunVC animated:YES];
    }
    else if (indexPath.section == 3) {
        IndexShopDetailViewController *vc = [[IndexShopDetailViewController alloc] init];
        vc.shopId = self.otherShopList[indexPath.row][@"Id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_app_ hiddenTabBar];
}

@end
