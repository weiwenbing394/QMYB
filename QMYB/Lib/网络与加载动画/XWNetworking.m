//
//  XWPNetworking.m
//  XW_MB_AF_MANAGER
//
//  Created by 大家保 on 2016/10/19.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "XWNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MBProgressHUD+ADD.h"
#define RootUrl   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MyImages"]

static NSMutableArray *tasks;

@implementation XWNetworking

/**
 *  单例
 */
+ (XWNetworking *)sharedXWNetworking{
    static XWNetworking *handler=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler=[[XWNetworking alloc]init];
    });
    return handler;
};

/**
 *  任务数组
 */
+ (NSMutableArray *)tasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks=[[NSMutableArray alloc]init];
    });
    return tasks;
}


/**
 *  开启网络监测
 */
+ (void)startMonitoring{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status){
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                
                [XWNetworking sharedXWNetworking].networkStats=StatusUnknown;
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
                [XWNetworking sharedXWNetworking].networkStats=StatusNotReachable;
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                
                [XWNetworking sharedXWNetworking].networkStats=StatusReachableViaWWAN;
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                [XWNetworking sharedXWNetworking].networkStats=StatusReachableViaWiFi;
                
                break;
        }
    }];
    
    [mgr startMonitoring];

};

/**
 *  获取网络状态
 */
+ (NetworkStatu)checkNetStatus{
    
    [self startMonitoring];
    
    if ([XWNetworking sharedXWNetworking].networkStats == StatusReachableViaWiFi) {
        
        return StatusReachableViaWiFi;
        
    } else if ([XWNetworking sharedXWNetworking].networkStats == StatusNotReachable) {
        
        return StatusNotReachable;
        
    } else if ([XWNetworking sharedXWNetworking].networkStats == StatusReachableViaWWAN) {
        
        return StatusReachableViaWWAN;
        
    } else {
        
        return StatusUnknown;
        
    }

};

/**
 *  是否有网络连接
 */
+ (BOOL) isHaveNetwork{
    
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    if ([conn currentReachabilityStatus] == NotReachable) {
        
        return NO;
        
    } else {
        
        return YES;
    }
};

/**
 *  Get请求
 */
+ (XWURLSessionTask *)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:GET resPonseType:JSON url:url params:params success:success fail:fail showHUD:showHUD];
};


/**
 *  POST请求
 */
+ (XWURLSessionTask *)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:POST resPonseType:JSON url:url params:params success:success fail:fail showHUD:showHUD];
};

/**
 *  Get请求,返回data
 */
+ (XWURLSessionTask *)getWithUrlAndResponseData:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:GET resPonseType:DATA url:url params:params success:success fail:fail showHUD:showHUD];
};


/**
 *  POST请求,返回data
 */
+ (XWURLSessionTask *)postWithUrlAndResponseData:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:POST resPonseType:DATA url:url params:params success:success fail:fail showHUD:showHUD];
};

/**
 *  post 或者 get 请求方法,block回调
 *  @param type             网络请求类型
 *  @param url              请求连接，根路径
 *  @param params           参数字典
 *  @param success          请求成功返回数据
 *  @param fail             请求失败
 *  @param showHUD          是否显示HUD
 */
+ (XWURLSessionTask *)baseRequestType:(httpMethod)type resPonseType:(responseType)responseType url:(NSString *)url params:(NSDictionary *)params  success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHUD:(BOOL)showHUD {
    
    //没有网络
    if ([self isHaveNetwork]==NO) {
        
        [MBProgressHUD ToastInformation:@"网络似乎不佳..."];
        
        return nil;
    }
    
    if (url==nil) {
        
        return nil;
    }
    
    if (showHUD == YES) {
                
        [MBProgressHUD showHUDWithTitle:@"加载中..."];
    }
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    AFHTTPSessionManager *manager;
    
    if (responseType==JSON) {
        
        manager=[self getAFJsonManager];
        
    }else{
        
        manager=[self getAFHttpManager];
    }
    
    XWURLSessionTask *sessionTask=nil;
    
    if (type== GET) {
        
        sessionTask = [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                
                success(responseObject);
            }
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES) {
                
                [MBProgressHUD hiddenHUD];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (fail) {
                
                fail(error);
            }
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES) {
                
                [MBProgressHUD hiddenHUD];
                
            }
            
        }];
        
    }else{
        
        sessionTask = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                
                success(responseObject);
                
            }
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES) {
                
                [MBProgressHUD hiddenHUD];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (fail) {
                
                fail(error);
            }
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES) {
                
                [MBProgressHUD hiddenHUD];
                
            }
            
        }];
        
    }
    
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    
    return sessionTask;
    
}


/**
 *  上传图片方法 支持多张上传和单张上传
 *  @param imageArr      上传的图片数组
 *  @param url        请求连接，根路径
 *  @param filename   图片的名称(如果不传则以当前时间命名)
 *  @param nameArr      上传图片时参数数组 <后台 处理文件的[字段]>
 *  @param params     参数字典
 *  @param progress   上传进度
 *  @param success    请求成功返回数据
 *  @param fail       请求失败返回数据
 *  @param showHUD    是否显示HUD
 *  @return           返回请求任务对象，便于操作
 */
+ (XWURLSessionTask *)uploadWithImages:(NSArray<UIImage *> *)imageArr url:(NSString *)url filename:(NSString *)filename names:(NSArray *)nameArr params:(NSDictionary *)params  progress:(XWUploadProgress)progress success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHUD:(BOOL)showHUD{
    
    //没有网络
    if ([self isHaveNetwork]==NO) {
        
        [MBProgressHUD ToastInformation:@"网络似乎不佳..."];
        
        return nil;
    }

    if (url==nil) {
        
        return nil;
        
    }
    
    if (showHUD==YES) {
        
        [MBProgressHUD showHUDWithTitle:@"正在上传..."];
    }
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    AFHTTPSessionManager *manager=[self getAFJsonManager];
    
    XWURLSessionTask *sessionTask = [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < imageArr.count; i ++) {
            
            UIImage *image = (UIImage *)imageArr[i];
            
            NSData *imageData = UIImageJPEGRepresentation(image,1.0);
            
            NSString *imageFileName = filename;
            
            if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                imageFileName = [NSString stringWithFormat:@"%@.png", str];
            }
            
            NSString *nameString = (NSString *)nameArr[i];
            
            [formData appendPartWithFileData:imageData name:nameString fileName:imageFileName mimeType:@"image/jpg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
        [[self tasks] removeObject:sessionTask];
        
        if (showHUD==YES) {
            
            [MBProgressHUD hiddenHUD];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {
            
            fail(error);
        }
        
        [[self tasks] removeObject:sessionTask];
        
        if (showHUD==YES) {
            
            [MBProgressHUD hiddenHUD];
        }
        
    }];
    
    if (sessionTask) {
        
        [[self tasks] addObject:sessionTask];
        
    }
    
    return sessionTask;
    
};

/**
 *  下载文件方法
 *  @param url           下载地址
 *  @param saveToPath    文件保存的路径,如果不传则保存到Documents目录下，以文件本来的名字命名
 *  @param progressBlock 下载进度回调
 *  @param success       下载完成
 *  @param fail          失败
 *  @param showHUD       是否显示HUD
 *  @return              返回请求任务对象，便于操作
 */
+ (XWURLSessionTask *)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath  progress:(XWDownloadProgress )progressBlock  success:(XWResponseSuccess )success failure:(XWResponseFail )fail showHUD:(BOOL)showHUD{
    
    if (url==nil) {
        return nil;
    }
    
    if (showHUD==YES) {
        
        [MBProgressHUD showHUDWithTitle:@"正在下载..."];
        
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPSessionManager *manager = [self getAFHttpManager];
    
    XWURLSessionTask *sessionTask = nil;
    
    sessionTask = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载进度--%.1f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (progressBlock) {
                
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (!saveToPath) {
//      NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory   inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//            NSLog(@"默认路径--%@",downloadURL);
//            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
            NSString *filePath=[response suggestedFilename];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL isDir = FALSE;
            BOOL isDirExist = [fileManager fileExistsAtPath:RootUrl isDirectory:&isDir];
            if(!(isDirExist && isDir)){
                BOOL bCreateDir = [fileManager createDirectoryAtPath:RootUrl  withIntermediateDirectories:YES attributes:nil error:nil];
                if(!bCreateDir){
                    return nil;
                }
                NSString *fileUrl=[RootUrl stringByAppendingPathComponent:filePath];
                NSURL *url=[NSURL fileURLWithPath:fileUrl];
                return url;
            }else{
                NSString *fileUrl=[RootUrl stringByAppendingPathComponent:filePath];
                NSURL *url=[NSURL fileURLWithPath:fileUrl];
                return url;
            }
            
        }else{
            
            return [NSURL fileURLWithPath:saveToPath];
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self tasks] removeObject:sessionTask];
        
        if (error == nil) {
            
            if (success) {
                
                success([filePath path]);//返回完整路径
                
            }
            
        } else {
            
            if (fail) {
                
                fail(error);
                
            }
        }
        
        if (showHUD==YES) {
            
            [MBProgressHUD hiddenHUD];
        }
        
    }];
    
    //开始下载
    [sessionTask resume];

    if (sessionTask) {
        
        [[self tasks] addObject:sessionTask];
        
    }
    
    return sessionTask;
    
};


/**
 *  获取AFHTTPSessionManager  (返回数据为json)
 */
+ (AFHTTPSessionManager *)getAFJsonManager{
    
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval= 60;
    
    //[manager.requestSerializer setValue:@"测试头文字" forHTTPHeaderField:@"服务器取值字段"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
    
    return manager;
    
}

/**
 *  获取AFHTTPSessionManager  (返回数据为NSData)
 */
+ (AFHTTPSessionManager *)getAFHttpManager{
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置返回NSData数据
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval= 60;
    
    //[manager.requestSerializer setValue:@"测试头文字" forHTTPHeaderField:@"服务器取值字段"];
    

    return manager;
    
}



/**
 *  字符编码转换
 */
+ (NSString *)strUTF8Encoding:(NSString *)str{
    
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
