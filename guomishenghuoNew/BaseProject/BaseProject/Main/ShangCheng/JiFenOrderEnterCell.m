//
//  JiFenOrderEnterCell.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/14.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "JiFenOrderEnterCell.h"

@interface JiFenOrderGoodView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;


@end

@implementation JiFenOrderGoodView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JiFenOrderEnterCell" owner:nil options:nil][1];
    }
    return self;
}

@end



@interface JiFenOrderEnterCell() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@property (weak, nonatomic) IBOutlet UIButton *peisongBtn;

@property (weak, nonatomic) IBOutlet UITextView *msgTextView;


@end

@implementation JiFenOrderEnterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JiFenOrderEnterCell" owner:nil options:nil][0];
        
        self.msgTextView.delegate = self;
    }
    return self;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.msgEditBlock) {
        self.msgEditBlock(textView.text);
    }
}

- (IBAction)clickPeisong:(id)sender {
    if (self.peisongBlock) {
        self.peisongBlock();
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    self.shopNameLabel.text = [NSString stringWithFormat:@"%@", data[@"ShopName"]];
//    if (data[@"type"] && [data[@"type"] integerValue] == 1) {
//        [self.peisongBtn setTitle:[NSString stringWithFormat:@"到付"] forState:UIControlStateNormal];
//    } else {
//        [self.peisongBtn setTitle:[NSString stringWithFormat:@"快递, 运费:%.2lf", [data[@"TransportationFee"] doubleValue]] forState:UIControlStateNormal];
//    }
    self.sumLabel.text = [NSString stringWithFormat:@"￥%.2lf", [data[@"TotalPrice"] doubleValue]];
    self.msgTextView.text = [NSString stringWithFormat:@"%@", data[@"msg"] ? data[@"msg"] : @""];
    
    [self.goodsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger count = 0;
    
    for (int i = 0; i < [data[@"BillDetailList"] count]; i++) {
        NSDictionary *obj = data[@"BillDetailList"][i];
        count += [obj[@"ProductNum"] integerValue];
        
        JiFenOrderGoodView *v = [[JiFenOrderGoodView alloc] init];
        [self.goodsView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(i * 80);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(80);
        }];
        
        [v.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.40.189.165/%@", obj[@"ProductImage"]]] placeholderImage:[UIImage imageNamed:@""]];
        v.label1.text = [NSString stringWithFormat:@"%@", obj[@"ProductName"]];
        v.label2.text = [NSString stringWithFormat:@"%@", obj[@"ProductPriceName"]];
        v.label3.text = [NSString stringWithFormat:@"￥%@", obj[@"ProductPrice"]];
        v.label4.text = [NSString stringWithFormat:@"×%@", obj[@"ProductNum"]];
    }
    
    if (count >= 5) {
        [self.peisongBtn setTitle:[NSString stringWithFormat:@"满5件，包邮"] forState:UIControlStateNormal];
    } else {
        [self.peisongBtn setTitle:@"到付" forState:UIControlStateNormal];
    }
}




- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
