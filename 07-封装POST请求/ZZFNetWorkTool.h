//
//  ZZFNetWorkTool.h
//  07-封装POST请求
//
//  Created by 左忠飞 on 16/4/24.
//  Copyright © 2016年 zzf.con. All rights reserved.
//

#import <Foundation/Foundation.h>


//定义成功回调和失败回调
//1 成功回调
typedef void (^successBlock)(NSData *data, NSURLResponse *response);

//2 失败回调
typedef void (^falseBlock)(NSError *error);

@interface ZZFNetWorkTool : NSObject

+(instancetype)shareNetWorkTool;


//一句话的POST请求
//urlstring:网络接口
//网络参数:参数字典
-(void)POSTWtithUrlString:(NSString *)urlstring paramaters:(NSDictionary *)paramaters successHandle:(successBlock)successHandle falseHandle:(falseBlock)falseHandle;

//获取请求体对象
-(NSData *)getHttpBodyWithKeyName:(NSString *)key fileName:(NSString *)fileName fileType:(NSString *)fileType filePath:(NSString *)filePath;

-(void)PostSingleFileUploadWithurlString:(NSString *)urlString filePath:(NSString *)filePath;




@end
