//
//  TakeOutViewCell.h
//  智慧社区
//
//  Created by 陈程 on 15/5/26.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TakeOutModel;


@protocol TakeOutViewCellDelegate <NSObject>

@optional
- (void)cellShowCountViewWithPath:(NSIndexPath *)indexPath;
- (void)cellNotShowCountViewWithPath:(NSIndexPath *)indexPath;
- (void)cellOrderAddPath:(NSIndexPath *)indexPath;
- (void)cellOrderSubPath:(NSIndexPath *)indexPath;
@end
@interface TakeOutViewCell : UITableViewCell
@property (nonatomic,strong) TakeOutModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<TakeOutViewCellDelegate> delegate;

- (instancetype)cellWithTableView:(UITableView *)tableview;
@end
