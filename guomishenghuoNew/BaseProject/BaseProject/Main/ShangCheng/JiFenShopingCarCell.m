//
//  JiFenShopingCarCell.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/11.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "JiFenShopingCarCell.h"



@implementation JiFenShopingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectBlock) {
        self.selectBlock(sender.selected);
    }
}

- (IBAction)subNum:(id)sender {
    if (self.subNumBlock) {
        self.subNumBlock();
    }
}

- (IBAction)plusNum:(id)sender {
    if (self.plusNumBlock) {
        self.plusNumBlock();
    }
}

- (IBAction)delete:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end

@implementation JiFenShopingCarHeader

- (IBAction)selBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectBlock) {
        self.selectBlock(sender.selected);
    }
}

@end
