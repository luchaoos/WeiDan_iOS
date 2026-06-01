//
//  JiFenShopingCarCell.h
//  BaseProject
//
//  Created by 陆超 on 2017/7/11.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiFenShopingCarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTxt;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (nonatomic, copy) void (^selectBlock)(BOOL isSel);
@property (nonatomic, copy) void (^subNumBlock)();
@property (nonatomic, copy) void (^plusNumBlock)();
@property (nonatomic, copy) void (^deleteBlock)();

@end

@interface JiFenShopingCarHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, copy) void (^selectBlock)(BOOL isSel);
@end
