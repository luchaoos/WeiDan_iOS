//
//  MyTextView.h
//  KongFuCenter
//
//  Created by Wangjc on 16/1/25.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MyTextView;
@protocol MyTextViewDelegate <NSObject>
@optional
-(BOOL)mytextView:(MyTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
-(void)myTextViewDidChange:(MyTextView *)textView;
-(void)myTextViewDidBeginEditing:(MyTextView *)textView;
-(void)mytextViewDidEndEditing:(MyTextView *)textView;
@end

@interface MyTextView : UITextView<UITextViewDelegate>
@property(nonatomic,strong) UILabel *placeHolder;
@property(nonatomic) id<MyTextViewDelegate> mydelegate;
@end
