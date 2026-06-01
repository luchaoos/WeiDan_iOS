//
//  CustomLabel.h
//  BaseProject
//
//  Created by 刘顺 on 16/10/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame withContent:(NSString *)city font:(CGFloat)font andRGBr:(CGFloat)r RGBg:(CGFloat)g RGBb:(CGFloat)b adaptive:(BOOL)adaptive;
@end
