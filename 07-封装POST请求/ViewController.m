//
//  ViewController.m
//  07-封装POST请求
//
//  Created by 左忠飞 on 16/4/24.
//  Copyright © 2016年 zzf.con. All rights reserved.
//

#import "ViewController.h"
#import "ZZFNetWorkTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self postSingleFileUpload];
}

//一句话封装POST请求
-(void)post{
    NSLog(@"开始了");
    
    //目标:一句话封装POST请求
    //对于网路请求
    //1 网络接口:URL
    //2 请求方法POST
    //3 请求体(请求参数)
    //4 请求完成之后的回调
    
    //一句话POST请求
    NSString *urlString = @"http://127.0.0.1/login/login.php";
    
    NSDictionary *dict = @{@"username":@"zhangsan",@"password":@"zhang"};
    
    [[ZZFNetWorkTool shareNetWorkTool]POSTWtithUrlString:urlString paramaters:dict successHandle:^(NSData *data, NSURLResponse *response) {
        NSLog(@"data:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSLog(@"%@",[NSThread currentThread]);
    } falseHandle:^(NSError *error) {
        
    }];
}


//上传文件到服务器
-(void)postSingleFileUpload{
    
    [[ZZFNetWorkTool shareNetWorkTool]PostSingleFileUploadWithurlString:@"http://127.0.0.1/upload/upload.php" filePath:@"/Users/zuozhongfei/Desktop/vedios.json"];
}

@end
