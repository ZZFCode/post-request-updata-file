//
//  ZZFNetWorkTool.m
//  07-封装POST请求
//
//  Created by 左忠飞 on 16/4/24.
//  Copyright © 2016年 zzf.con. All rights reserved.
//
#define KBOUNDARY @"boundary"

#import "ZZFNetWorkTool.h"

@implementation ZZFNetWorkTool


//创建一个单例方法
+(instancetype)shareNetWorkTool{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
-(void)POSTWtithUrlString:(NSString *)urlstring paramaters:(NSDictionary *)paramaters successHandle:(successBlock)successHandle falseHandle:(falseBlock)falseHandle
{
    // 1. 创建网络请求
    NSURL *url = [NSURL URLWithString:urlstring];
    
    // 1.1 可变请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    
    // 1.2 设置请求方法
    request.HTTPMethod = @"POST";
    
    // 1.3 设置请求体(封装参数)
    
    NSMutableString *strM = [NSMutableString string];
    
    // 1.3.1 遍历参数字典.
    [paramaters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *paramaterKey = key;
        
        NSString *paramaterValue = obj;
        
        // 拼接参数字符串.
        [strM appendFormat:@"%@=%@&",paramaterKey,paramaterValue];
    }];
    
    // 1.3.2 截取参数字符串(去掉最后一个&)
    NSString *paramater  = [strM substringToIndex:strM.length - 1];
    
    request.HTTPBody = [paramater dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2. 发送请求
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 成功
        if (data && !error) {
            
            //执行成功回调
            if (successHandle) {
                successHandle(data ,response);
                
                NSLog(@"-----------------%@",[NSThread currentThread]);
            }
            
        }else
        {
            // 执行失败回调
            if (falseHandle) {
                falseHandle(error);
            }
        }
        
        
        
    }] resume];
    
}















/**
 *  封装请求体
 *
 *  @param key      服务器接收文件参数的key值
 *  @param fileName 上传文件在服务器中的保存名称
 *  @param fileType 文件类型
 *  @param filePath 上传文件的路径(本地绝对路径)
 *
 *  @return 返回请求体数据
 */
-(NSData *)getHttpBodyWithKeyName:(NSString *)key fileName:(NSString *)fileName fileType:(NSString *)fileType filePath:(NSString *)filePath{
    //创建可变的二进制数据Data
    NSMutableData *data = [NSMutableData data];
    //1 拼接上边界
    NSMutableString *hearderStrM = [NSMutableString stringWithFormat:@"--%@\r\n",KBOUNDARY];
    [hearderStrM appendFormat:@"Content-Disposition: form-data;name=%@;filename=%@\r\n",key,fileName];
    
    [hearderStrM appendFormat:@"Content_Type:%@\r\n\r\n",fileType];
    
    //把上边界字符加到data中
    [data appendData:[hearderStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    //2 拼接文件内容
    NSData *fielData = [NSData dataWithContentsOfFile:filePath];
    [data appendData:fielData];
    
    //3 拼接下边界
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n--%@--",KBOUNDARY];
    [data appendData:[footerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}


//创建请求
-(void)PostSingleFileUploadWithurlString:(NSString *)urlString1 filePath:(NSString *)filePath1{
    NSLog(@"开始...");
    
    //创建请求
    NSString *urlString = urlString1;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方法
    request.HTTPMethod = @"POST";
    
    //文件上传,必须通过请求头:Content-Type来告诉服务器和POST请求请求体的数据格式,并且还有边界格式
    NSString *type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",KBOUNDARY];
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    
    //封装请求体格式
    //要上传的文件路径
    NSString *filePath = filePath1;
    request.HTTPBody = [[ZZFNetWorkTool shareNetWorkTool]getHttpBodyWithKeyName:@"userfile" fileName:@"1234567" fileType:@"text.xml" filePath:filePath];
    
    //发送请求
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"response:%@",response);
        NSLog(@"data:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSLog(@"结束...");
        
    }]resume];
}


@end
