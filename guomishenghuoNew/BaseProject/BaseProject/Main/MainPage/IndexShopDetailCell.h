//
//  IndexShopDetailCell.h
//  BaseProject
//
//  Created by 陆超 on 2017/8/11.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWStarRateView;
@interface IndexShopDetailCell : UITableViewCell

@end

@interface IndexShopDetailTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet CWStarRateView *starView;

@property (nonatomic, copy) void(^callBlock)();
@property (nonatomic, copy) void(^payInShopBlock)();
@property (nonatomic, copy) void(^navBlock)();
@property (nonatomic, copy) void(^photosBlock)();

@end

@interface IndexShopDetailWebCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@interface IndexShopDetailCmtCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CWStarRateView *starView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *cmtNumLabel;

@end

@interface IndexShopDetailOtherShopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet CWStarRateView *starView;


@end
