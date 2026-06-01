//
//  JSTextView.m
//  Grade
//
//  Created by 刘顺 on 16/10/13.
//  Copyright © 2016年 LiuShun. All rights reserved.
//

#import "JSTextView.h"


@interface JSTextView ()<UITextViewDelegate>
@property (nonatomic,weak) UILabel *placeholderLabel;
@property (nonatomic,weak) UILabel *bottomPlaceholderLabel;
@property (nonatomic, assign)NSInteger num;
@end
@implementation JSTextView


- (instancetype)initWithFrame:(CGRect)frame size:(CGFloat)size numLimit:(BOOL)limit{
    
    self = [super initWithFrame:frame];
    
    if(self) {
        
        _numLimit = limit;
        self.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
        self.delegate = self;
        UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
        UILabel *bottomPlaceholderLabel = [[UILabel alloc]init];
        
        placeholderLabel.backgroundColor= [UIColor clearColor];
        bottomPlaceholderLabel.backgroundColor= [UIColor clearColor];
        bottomPlaceholderLabel.textColor = [UIColor lightGrayColor];
        bottomPlaceholderLabel.font = [UIFont systemFontOfSize:15];
        bottomPlaceholderLabel.frame = CGRectMake(self.frame.size.width-150, self.frame.size.height - 30, 150, 30);
        bottomPlaceholderLabel.text = @"还可以输入140字";
        
        placeholderLabel.numberOfLines=0; //设置可以输入多行文字时可以自动换行
        bottomPlaceholderLabel.numberOfLines=0;
        
        [self addSubview:placeholderLabel];
        [self addSubview:bottomPlaceholderLabel];
        
        self.placeholderLabel= placeholderLabel; //赋值保存
        self.bottomPlaceholderLabel = bottomPlaceholderLabel;
        self.bottomPlaceholderLabel.textAlignment = NSTextAlignmentRight;
        
        
        self.myPlaceholderColor= [UIColor lightGrayColor]; //设置占位文字默认颜色'
        
        
        self.font= [UIFont systemFontOfSize:15]; //设置默认的字体
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
        
        
        _btn = [UIButton buttonWithType:UIButtonTypeSystem];
        _btn.frame = CGRectMake(10, self.frame.size.height - size-10, size, size);
        [self addSubview:_btn];
        [_btn setBackgroundImage:[UIImage imageNamed:@"tianjiatupian"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(pictureClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 是否开启数字限制
        if (_numLimit) {
            bottomPlaceholderLabel.hidden = NO;
        }else{
            bottomPlaceholderLabel.hidden =  YES;
            _btn.hidden = YES;
        }
    }
    
    return self;
    
}
- (void)pictureClick{
    [self.LSDelegate uploadPicture:self];
}
#pragma mark -监听文字改变

- (void)textDidChange {
    
    self.placeholderLabel.hidden = self.hasText;
    self.bottomPlaceholderLabel.text = [NSString stringWithFormat:@"还可以输入%ld字", _num];
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect frame = self.placeholderLabel.frame;
    
    frame.origin.y = 8;
    frame.origin.x = 5;
    frame.size.width = self.frame.size.width - frame.origin.x*2.0;
    
    
    
    
    CGSize maxSize =CGSizeMake(frame.size.width,MAXFLOAT);
    
    frame.size.height= [self.myPlaceholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    
    self.placeholderLabel.frame = frame;
    
}
- (void)setMyPlaceholder:(NSString*)myPlaceholder{
    
    _myPlaceholder= [myPlaceholder copy];
    
    //设置文字
    
    self.placeholderLabel.text= myPlaceholder;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}
- (void)setMyPlaceholderColor:(UIColor*)myPlaceholderColor{
    
    _myPlaceholderColor= myPlaceholderColor;
    
    //设置颜色
    
    self.placeholderLabel.textColor= myPlaceholderColor;
    
}
//重写这个set方法保持font一致

- (void)setFont:(UIFont*)font{
    
    [super setFont:font];
    
    self.placeholderLabel.font= font;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}
- (void)setText:(NSString*)text{
    
    [super setText:text];
    
    [self textDidChange]; //这里调用的就是 UITextViewTextDidChangeNotification 通知的回调
    
}
- (void)setAttributedText:(NSAttributedString*)attributedText{
    
    [super setAttributedText:attributedText];
    
    [self textDidChange]; //这里调用的就是UITextViewTextDidChangeNotification 通知的回调
    
}

#pragma mark textViewDelegate 文字限制
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_numLimit) {
        if (range.location>=140) {
            return NO;
        }
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    NSString  *nsTextContent=textView.text;
    NSInteger   existTextNum = nsTextContent.length;
    _num = 140 - existTextNum;
    if (_num < 0) {
        _num = 0;
    }
}

// 注销通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:UITextViewTextDidChangeNotification];
    
}

@end
