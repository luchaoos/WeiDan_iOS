//
//  IMRecentCell.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/30.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IMRecentCell.h"

@implementation IMRecentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
}

- (IBAction)btn1Click:(id)sender {
    if (self.btn1Block) {
        self.btn1Block();
    }
}

- (IBAction)btn2Click:(id)sender {
    if (self.btn2Block) {
        self.btn2Block();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = self.image.bounds.size.width * .5f;
    self.image.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.image.layer.borderWidth = 1.f;
}

@end
