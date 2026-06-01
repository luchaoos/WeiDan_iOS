//
//  AddNumView.h
//  TDS
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNumViewDelegate <NSObject>

-(void)AddNumView:(NSInteger)num;

@end

@interface AddNumView : UIView
{

    UIButton *minusBtn;
    UIButton *addBtn;
    UILabel *numLabel;
    UILabel *numLabel1;
    NSInteger num;
}

@property (nonatomic, weak) id<AddNumViewDelegate>delegate;
@property (nonatomic, strong)NSString * ID;

@property (nonatomic, assign) NSInteger numInteger;

@property (nonatomic, assign) NSInteger minInteget;

@end
