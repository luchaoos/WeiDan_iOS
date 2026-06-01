//
//  DrawLine.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "DrawLine.h"

@implementation DrawLine

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(220, 221, 223);
    }
    return self;
}
//+ (DrawLine *)returnLine{
//    DrawLine *line = [[DrawLine alloc]init];
//    line.backgroundColor = RGB(220, 221, 223);
//    return line;
//}
@end
