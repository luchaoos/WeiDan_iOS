//
//  UploadDataToServer.m
//  KongFuCenter
//
//  Created by Wangjc on 15/12/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UploadDataManager.h"
#import "UploadRequest.h"

@interface UploadDataToServer ()
{
    NSInteger uploadImgCount;
    NSMutableArray *imgPath;
    NSInteger allImgCount;
    NSArray *_imgArr;
    UploadRequest *request;
    
    UIAlertView *alertView;
}
@end

@implementation UploadDataToServer

-(id)init
{
    self = [super init];
    if(self)
    {
        imgPath = [NSMutableArray array];
        uploadImgCount = 0;
        alertView =[[UIAlertView alloc] initWithTitle:@"上传图片" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    }
    return self;

}

-(void)cancelUpload
{
    [request cancelPostRequest];
}

#pragma mark - upload img



-(void)uploadImg:(NSArray *)ImgArr
{
    if(ImgArr == nil || ImgArr.count == 0 )
        return;
    
    allImgCount = ImgArr.count;
    uploadImgCount = 0;
    _imgArr = ImgArr;
    [self requestToServer];
}

-(void)requestToServer
{
    request = [[UploadRequest alloc] init];
    [request setDelegateObject:self setSucceedBackFunctionName:@"uploadImgCallBack:" setFailBackFunctionName:@"uploadImgFailCallBack"];
    [request setdelegateObject:self setProgressFunctionName:@"uploadImgProgress:"];
    [request uploadImgWithFileName:@"imgsrc.jpg" andStream:_imgArr[uploadImgCount]];
    
}

-(void)uploadImgProgress:(NSString *)progress
{
    CGFloat pro = [progress floatValue];
    
    //在主线程 更新ui
    __unsafe_unretained __typeof(self) weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (weakSelf.progressBar !=nil) {
            weakSelf.progressBar.progress = pro;
            [weakSelf.progressBar setNeedsDisplay];
        }
    });
    
}



-(void)uploadImgFailCallBack
{
    [SVProgressHUD dismiss];
}

-(void)uploadImgCallBack:(id)dict
{
    DLog(@"%@",dict);
    [SVProgressHUD dismiss];
    @try {
        if(RequestSuccess(dict))
        {
            [imgPath addObject:dict[@"data"][@"BigImagePath"]];
            uploadImgCount ++;
            if([self.delegate respondsToSelector:@selector(uploadImgsOneFinishDelegate:andImgIndex:)])
            {
                [self.delegate uploadImgsOneFinishDelegate:dict andImgIndex:(uploadImgCount+1)];
            }
            
            if(uploadImgCount >= allImgCount)
            {
                if([self.delegate respondsToSelector:@selector(uploadImgsAllFinishDelegate:)])
                {
                    [self.delegate uploadImgsAllFinishDelegate:imgPath];
                }
            }
            else
            {
                [self requestToServer];
            }
        }
        else
        {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:ErrorMessage(dict) delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

@end
