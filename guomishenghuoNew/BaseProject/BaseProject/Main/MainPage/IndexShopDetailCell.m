//
//  IndexShopDetailCell.m
//  BaseProject
//
//  Created by 陆超 on 2017/8/11.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IndexShopDetailCell.h"
#import "CWStarRateView.h"

@implementation IndexShopDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation IndexShopDetailTopCell
- (IBAction)call:(id)sender {
    if (self.callBlock) {
        self.callBlock();
    }
}

- (IBAction)payInShop:(id)sender {
    if (self.payInShopBlock) {
        self.payInShopBlock();
    }
}
- (IBAction)nav:(id)sender {
    if (self.navBlock) {
        self.navBlock();
    }
}

- (IBAction)photos:(id)sender {
    if (self.photosBlock) {
        self.photosBlock();
    }
}
@end

@implementation IndexShopDetailWebCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end

@implementation IndexShopDetailCmtCell

@end

@implementation IndexShopDetailOtherShopCell

@end
