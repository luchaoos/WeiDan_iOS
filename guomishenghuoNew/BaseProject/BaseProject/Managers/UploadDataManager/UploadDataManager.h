//
//  UploadDataToServer.h
//  KongFuCenter
//
//  Created by Wangjc on 15/12/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uploadProgressBar.h"

@protocol UploadDataToServerDelegate <NSObject>
//全部图片都传完
-(void)uploadImgsAllFinishDelegate:(NSArray *)imgPath;
//每传完一张
-(void)uploadImgsOneFinishDelegate:(NSDictionary *)dict andImgIndex:(NSInteger)ImgIndex;

@end

@interface UploadDataToServer : NSObject
@property(nonatomic) id<UploadDataToServerDelegate> delegate;
/*
 *  上传多张图片
 *
 *  @param ImgArr 图片base64数据数组
 */
-(void)uploadImg:(NSArray *)ImgArr;
//取消上传
-(void)cancelUpload;
@property(nonatomic) uploadProgressBar *progressBar;//进度显示 目前只支持单个文件进度显示 多个的还未测试
@end

