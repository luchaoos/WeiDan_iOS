//
//  JSTextView.h
//  Grade
//
//  Created by 刘顺 on 16/10/13.
//  Copyright © 2016年 LiuShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSTextView;

@protocol JSTextViewDelegate <NSObject>

- (void)uploadPicture:(JSTextView *)view;

@end

@interface JSTextView : UITextView

@property (nonatomic, weak)id <JSTextViewDelegate> LSDelegate;

@property(nonatomic,copy) NSString *myPlaceholder;  //文字
@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色

@property (nonatomic, copy)NSString *bottomPlaceholde;
@property (nonatomic, strong)UIButton *btn;

@property (nonatomic, assign)BOOL numLimit;

- (instancetype)initWithFrame:(CGRect)frame size:(CGFloat)size numLimit:(BOOL)limit;
@end
