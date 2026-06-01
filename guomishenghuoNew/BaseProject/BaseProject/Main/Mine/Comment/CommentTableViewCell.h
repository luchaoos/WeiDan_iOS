//
//  CommentTableViewCell.h
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property(nonatomic)UIImageView *headImage;
@property(nonatomic)UILabel *nameLbl;
@property(nonatomic)UILabel *timeLbl;
@property(nonatomic)UILabel *commentLbl;
@property(nonatomic)UILabel *guigeLbl;
@property(nonatomic)UIImageView *goodImage;
@property(nonatomic)UIView *shopReply;
@property(nonatomic)UILabel *replyLbl;
@property(nonatomic)UILabel *replyContent;

@end
