//
//  UploadRequest.h
//  BaseProject
//
//  Created by Wangjc on 16/7/20.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface UploadRequest : BaseRequest
-(void)uploadImgWithFileName:(NSString *)fileName andStream:(NSString *)filestream;
@end
