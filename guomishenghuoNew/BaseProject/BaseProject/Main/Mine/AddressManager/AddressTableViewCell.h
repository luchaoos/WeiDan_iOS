//
//  AddressTableViewCell.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/7.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressTableViewCell;
@protocol AddressTableViewCellDelegate <NSObject>
-(void)addressCell:(AddressTableViewCell *)cell editBtnClick:(UIButton *)sender;
-(void)addressCell:(AddressTableViewCell *)cell DelBtnClick:(UIButton *)sender;
@end

@interface AddressTableViewCell : UITableViewCell
@property(nonatomic) BOOL editMode;
@property(nonatomic) id<AddressTableViewCellDelegate> delegate;
@end
