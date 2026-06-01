//
//  ShopDetialPingJiaTableViewCell.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/4/27.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "ShopDetialPingJiaTableViewCell.h"


@implementation ShopDetialPingJiaTableViewCell
{
    UIImageView * img_headerIcon;
    
    CGFloat lbl_ContentHeight;//评价内容lbl高度
    CGFloat lbl_addContentHeight;//追加评论的高度
    CGFloat lbl_shopperWritBackHeight;//商家回复的高度
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    // Initialization code
    
}
-(void)BuildAllCellView
{
    
    lbl_addContentHeight=0;
    lbl_ContentHeight=0;
    lbl_shopperWritBackHeight=0;
    img_headerIcon=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    [img_headerIcon sd_setImageWithURL:[NSURL URLWithString:self.model.img_Path] placeholderImage:[UIImage imageNamed:@"User"]];
    img_headerIcon.layer.masksToBounds=YES;
    img_headerIcon.layer.cornerRadius=25;
    [self.contentView addSubview:img_headerIcon];
    
    UILabel * lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, img_headerIcon.frame.origin.y, 90, 14)];
    lbl_date.text=self.model.pingJiaDate==nil?@"2016.03.04":self.model.pingJiaDate;
    lbl_date.font=[UIFont systemFontOfSize:10];
    lbl_date.textColor=[UIColor lightGrayColor];
    [self.contentView addSubview:lbl_date];
    
    
    
    UILabel * lbl_HeaderName=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_headerIcon.frame)+5, img_headerIcon.frame.origin.y, lbl_date.frame.origin.x-(CGRectGetMaxX(img_headerIcon.frame)+5), 20)];
    lbl_HeaderName.text=self.model.nickName==nil?@"佚名":self.model.nickName;
    [self.contentView addSubview:lbl_HeaderName];
    
    LHRatingView * rView = [[LHRatingView alloc]initWithFrame:CGRectMake(lbl_HeaderName.frame.origin.x, CGRectGetMaxY(lbl_HeaderName.frame)+10, 60*(SCREEN_WIDTH/320), 20)];
    //            rView.center = cell.PingjiaView.center;
    rView.ratingType = INTEGER_TYPE;//整颗星
    rView.score=3;
    rView.delegate = self;
    [self.contentView addSubview:rView];
    
    UILabel * lbl_TimeLong=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rView.frame)+5, rView.frame.origin.y, SCREEN_WIDTH-(CGRectGetMaxX(rView.frame)+5), 20)];
    lbl_TimeLong.textColor=[UIColor grayColor];
    lbl_TimeLong.font=[UIFont systemFontOfSize:14];
    lbl_TimeLong.text=self.model.timeLong==nil?@"立即送达":[NSString stringWithFormat:@"%@分钟送达",self.model.timeLong];
    [self.contentView addSubview:lbl_TimeLong];
    
    lbl_ContentHeight=20;
    if (self.model.pinglunContent!=nil) {
        lbl_ContentHeight=[Toolkit heightWithString:self.model.pinglunContent fontSize:18 width:SCREEN_WIDTH-lbl_HeaderName.frame.origin.x-10]+10;
    }
    
    
    UILabel * lbl_Content=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_headerIcon.frame)+5, CGRectGetMaxY(rView.frame), SCREEN_WIDTH-lbl_HeaderName.frame.origin.x-10, lbl_ContentHeight)];
    lbl_Content.numberOfLines=0;
    lbl_Content.text=self.model.pinglunContent==nil?@"默认评论":self.model.pinglunContent;
    lbl_Content.font=[UIFont systemFontOfSize:18];
    [self.contentView addSubview:lbl_Content];
    
    if (![self.model.addContent isEqualToString:@""]) {
        lbl_addContentHeight=[Toolkit heightWithString:self.model.addContent fontSize:18 width:lbl_Content.frame.size.width]+10;
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.headIndent = 10;//头部缩进，相当于左padding
        style.tailIndent = -10;//相当于右padding
        style.firstLineHeadIndent=10;
        style.alignment = NSTextAlignmentLeft;//对齐方式
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.model.addContent];
        [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attrString.length)];
        
        UILabel * lbl_AddContent=[[UILabel alloc] initWithFrame:CGRectMake(lbl_Content.frame.origin.x, CGRectGetMaxY(lbl_Content.frame)+10, lbl_Content.frame.size.width, lbl_addContentHeight)];
        lbl_AddContent.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
        lbl_AddContent.textColor=[UIColor grayColor];
        lbl_AddContent.attributedText=attrString;
        lbl_AddContent.numberOfLines=0;
        [self.contentView addSubview:lbl_AddContent];
    }
    if (![self.model.shopperWritBack isEqualToString:@""]) {
        lbl_shopperWritBackHeight=[Toolkit heightWithString:self.model.shopperWritBack fontSize:18 width:lbl_Content.frame.size.width]+10;
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.headIndent = 10;//头部缩进，相当于左padding
        style.tailIndent = -10;//相当于右padding
        style.firstLineHeadIndent=10;
        style.alignment = NSTextAlignmentLeft;//对齐方式
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.model.shopperWritBack];
        [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attrString.length)];
        UIView * lastView=[self.contentView.subviews lastObject];
        UILabel * lbl_ShopperWritBack=[[UILabel alloc] initWithFrame:CGRectMake(lastView.frame.origin.x, CGRectGetMaxY(lastView.frame)+10, lbl_Content.frame.size.width, lbl_addContentHeight)];
        lbl_ShopperWritBack.backgroundColor=[UIColor lightGrayColor];
        lbl_ShopperWritBack.textColor=[UIColor grayColor];
        lbl_ShopperWritBack.attributedText=attrString;
        lbl_ShopperWritBack.numberOfLines=0;
//        [self.contentView addSubview:lbl_ShopperWritBack];
    }
    
}



/**
 *  商户页面评价cell计算高度
 *
 *  @return <#return value description#>
 */
+(CGFloat)JiSuanCellHeight:(ShopDetialPingJiaCellModel *)model
{
    CGFloat cellHeight=70;
    if (model.pinglunContent!=nil) {
        cellHeight+=[Toolkit heightWithString:model.pinglunContent fontSize:18 width:SCREEN_WIDTH-80]+10;
    }
    if (model.addContent!=nil) {
        cellHeight+=[Toolkit heightWithString:model.addContent fontSize:18 width:SCREEN_WIDTH-80]+10;
    }
    if (model.shopperWritBack!=nil) {
        cellHeight+=[Toolkit heightWithString:model.shopperWritBack fontSize:18 width:SCREEN_WIDTH-80]+10;
    }
    return cellHeight;
}

#pragma mark - ratingViewDelegate
- (void)ratingView:(LHRatingView *)view score:(CGFloat)score
{
    NSLog(@"分数  %.2f",score);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
