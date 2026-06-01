//
//  CustomLabel.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (instancetype)initWithFrame:(CGRect)frame withContent:(NSString *)city font:(CGFloat)font andRGBr:(CGFloat)r RGBg:(CGFloat)g RGBb:(CGFloat)b adaptive:(BOOL)adaptive{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = city;
        self.font = [UIFont systemFontOfSize:font];
        self.textColor = RGB(r, g, b);
        if (adaptive == YES) {
            [self labelAdaptiveSize];
        }
    }
    return self;
}
// 宽高自适应
- (void)labelAdaptiveSize{
    [self setNumberOfLines:0];
    //初始化段落，设置段落风格
    NSMutableParagraphStyle *paragraphstyle=[[NSMutableParagraphStyle alloc]init];
    paragraphstyle.lineBreakMode=NSLineBreakByCharWrapping;
    NSDictionary *dict = @{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraphstyle.copy};
    //计算label的真正大小,其中宽度和高度是由段落字数的多少来确定的，返回实际label的大小
    CGRect rectt = [self.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGRect oldRect = self.frame;
    //设置到屏幕顶部的距离，如果不设置就x,y都为0
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, oldRect.size.width,rectt.size.height);
}
@end
