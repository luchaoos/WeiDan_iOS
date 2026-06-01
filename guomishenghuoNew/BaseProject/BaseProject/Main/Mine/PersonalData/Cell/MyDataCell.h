//
//  MyDataCell.h
//  BaseProject
//
//  Created by 刘顺 on 16/10/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDataCell : UITableViewCell

@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *rightLabel;
@property (nonatomic, strong)UIImageView *imgView;

- (MyDataCell *)cellWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath;
@end
