//
//  TakeOutHeader.m
//  智慧社区
//
//  Created by 陈程 on 15/5/26.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "TakeOutHeader.h"

@interface TakeOutHeader()
@property (nonatomic,weak) UILabel *title;
@end

@implementation TakeOutHeader

+ (instancetype)headerWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"TakeOutHeader";
    TakeOutHeader *header = [tableview dequeueReusableCellWithIdentifier:ID];
    if (header == nil) {
        header = [[TakeOutHeader alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 200, 20)];
        title.font = [UIFont systemFontOfSize:11];
        self.title = title;
        [self.contentView addSubview:title];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.title.text = titleStr;
}


@end
