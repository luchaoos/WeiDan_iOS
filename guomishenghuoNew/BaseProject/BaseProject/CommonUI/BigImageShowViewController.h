//
//  BigImageShowViewController.h
//  KongFuCenter
//
//  Created by Rain on 16/2/2.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseViewController.h"

@interface BigImageShowViewController : BaseViewController{
    CGFloat lastScale;
    CGRect oldFrame;    //保存图片原来的大小
    CGRect largeFrame;  //确定图片放大最大的程度
}

@property(nonatomic,strong) NSArray *imgUrl;

@end
