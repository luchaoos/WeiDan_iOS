//
//  UploadRequest.m
//  BaseProject
//
//  Created by Wangjc on 16/7/20.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "UploadRequest.h"

@implementation UploadRequest

-(void)uploadImgWithFileName:(NSString *)fileName andStream:(NSString *)filestream
{
    if (fileName && filestream) {
        NSString *url = [NSString stringWithFormat:@"%@Login.asmx/UpLoadImage",BaseUrl];
        NSDictionary *  prm=@{@"fileName":fileName,@"filestream":filestream};;
        //        ELog(prm);
        [self postRequst:url andPrm:prm];
    }
}

@end
