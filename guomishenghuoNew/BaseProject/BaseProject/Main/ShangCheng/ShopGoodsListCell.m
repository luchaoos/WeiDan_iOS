//
//  ShopGoodsListCell.m
//  BaseProject
//
//  Created by 陆超 on 2017/6/17.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "ShopGoodsListCell.h"
#import "SDCycleScrollView.h"

@implementation ShopGoodsListCell {
    
    __weak IBOutlet UIImageView *_image;
    __weak IBOutlet UILabel *_label1;
    __weak IBOutlet UILabel *_label2;
    __weak IBOutlet UILabel *_label3;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ShopGoodsListCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data[@"ImagePath"]]]
              placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    _label1.text = [NSString stringWithFormat:@"%@", data[@"Name"]];
    _label2.text = [NSString stringWithFormat:@"%.2lf￥", [data[@"Price"] doubleValue]];
    _label3.text = [NSString stringWithFormat:@"库存:%@  已售:%@", data[@"StockNum"], data[@"SaleNum"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation ShopGoodsTopCell {
    
    __weak IBOutlet SDCycleScrollView *cycleScrollView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ShopGoodsListCell" owner:nil options:nil][1];
//        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeHolder"];
        cycleScrollView.autoScrollTimeInterval = 5.f;
//        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        
    }
    return self;
}

- (void)setImgURLs:(NSArray<NSString *> *)imgURLs {
    _imgURLs = imgURLs;
    cycleScrollView.imageURLStringsGroup = imgURLs;
}

- (void)setImgTitles:(NSArray<NSString *> *)imgTitles {
    _imgTitles = imgTitles;
    cycleScrollView.titlesGroup = imgTitles;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


