//
//  ShopErrorCell.h
//  BaseProject
//
//  Created by 刘顺 on 16/10/17.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopErrorCell : UITableViewCell

@property (nonatomic, strong)UILabel *leftLabel;


+ (ShopErrorCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
