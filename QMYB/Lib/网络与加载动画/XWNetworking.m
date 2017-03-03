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
#import "XWNetworkCache.h"
#import "QMYBLoginViewController.h"


@implementation XWNetworking

static AFHTTPSessionManager *manager = nil;

#pragma mark - 初始化AFHTTPSessionManager相关属性
+ (void)initialize{
    manager = [AFHTTPSessionManager manager];
    // 设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 20.f;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    [manager.requestSerializer setValue:VERSION forHTTPHeaderField:@"CL-app-v"];
    [manager.requestSerializer setValue:zhengShiCeShi forHTTPHeaderField:@"CL-app-m"];
    [manager.requestSerializer setValue:MYUUID forHTTPHeaderField:@"uuid"];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

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
    static NSMutableArray *tasks;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks=[[NSMutableArray alloc]init];
    });
    return tasks;
}

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(XWNetworkStatus)networkStatus{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 打开状态栏的等待菊花
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status){
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(StatusUnknown) : nil;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(StatusNotReachable) : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(StatusReachableViaWWAN) : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(StatusReachableViaWiFi) : nil;
                    break;
            }
        }];
        
    });
};

/**
 *  是否有网络连接
 */
+ (BOOL) isHaveNetwork{
    if(([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!= NotReachable)){
        return YES;
    }else{
        return NO;
    }
};



/**
 取消所有HTTP请求
 */
+ (void)cancelAllRequest{
    // 锁操作
    @synchronized(self){
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self tasks] removeAllObjects];
    }
};

/**
 取消指定URL的HTTP请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL{
    if (!URL){
        return;
    }
    @synchronized (self){
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self tasks] removeObject:task];
                *stop = YES;
            }
        }];
    }
};

#pragma mark 无缓存请求
/**
 *  Get请求
 */
+ (XWURLSessionTask *)getJsonWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:GET resPonseType:JSON url:url params:params responseCache:nil success:success fail:fail showHUD:showHUD];
};


/**
 *  POST请求
 */
+ (XWURLSessionTask *)postJsonWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:POST resPonseType:JSON url:url params:params responseCache:nil success:success fail:fail showHUD:showHUD];
};

/**
 *  Get请求,返回data
 */
+ (XWURLSessionTask *)getDataWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:GET resPonseType:DATA url:url params:params responseCache:nil success:success fail:fail showHUD:showHUD];
};


/**
 *  POST请求,返回data
 */
+ (XWURLSessionTask *)postDataWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:POST resPonseType:DATA url:url params:params responseCache:nil success:success  fail:fail showHUD:showHUD];
};

#pragma mark 有缓存请求
/**
 *  Get请求,返回json,有缓存
 */
+ (XWURLSessionTask *)getJsonWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:GET resPonseType:JSON url:url params:params responseCache:responseCache success:success fail:fail showHUD:showHUD];
};


/**
 *  POST请求,返回json,有缓存
 */
+ (XWURLSessionTask *)postJsonWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:POST resPonseType:JSON url:url params:params responseCache:responseCache success:success fail:fail showHUD:showHUD];
};

/**
 *  Get请求,返回data,有缓存
 */
+ (XWURLSessionTask *)getDataWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:GET resPonseType:DATA url:url params:params responseCache:responseCache success:success fail:fail showHUD:showHUD];
};


/**
 *  POST请求,返回data,有缓存
 */
+ (XWURLSessionTask *)postDataWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD{
    return [self baseRequestType:POST resPonseType:DATA url:url params:params responseCache:responseCache success:success  fail:fail showHUD:showHUD];
};


#pragma mark base请求
/**
 *  post 或者 get 请求方法,block回调
 *  @param type             网络请求类型
 *  @param url              请求连接，根路径
 *  @param params           参数字典
 *  @param success          请求成功返回数据
 *  @param fail             请求失败
 *  @param showHUD          是否显示HUD
 */
+ (XWURLSessionTask *)baseRequestType:(httpMethod)type resPonseType:(responseType)responseType url:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHUD:(BOOL)showHUD {
    
    NSLog(@"tokenID=%@  ,USERID=%@",[UserDefaults objectForKey:TOKENID],[[UserDefaults objectForKey:USERID] stringValue]);
    
    //没有网络
    if ([self isHaveNetwork]==NO) {
        
        [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        
    }else{
        
        if (showHUD == YES) {
            
            [MBProgressHUD showHUDWithTitle:@"加载中..."];
        }
    }
    // 读取缓存
    responseCache ? [XWNetworkCache httpCacheForURL:url parameters:params withBlock:responseCache] : nil;
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    //[self sharedAFManager];
    
    [manager.requestSerializer setValue:[UserDefaults objectForKey:TOKENID] forHTTPHeaderField:TOKENID];
    
    [manager.requestSerializer setValue:[[UserDefaults objectForKey:USERID] stringValue] forHTTPHeaderField:USERID];
    
    if (responseType==JSON) {
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
        
        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithArray:@[@"application/json", @"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
        
    }else{
        
       manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置返回NSData数据
    }
    
    XWURLSessionTask *sessionTask=nil;
    
    if (type== GET) {
        
        sessionTask = [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES&&[self isHaveNetwork]==YES) {
                
                [MBProgressHUD hiddenHUD];
            }
            
            if ([responseObject isKindOfClass:[NSDictionary class]]&&[[responseObject allKeys] containsObject:@"code"]) {
                
                NSInteger statusCode=[responseObject integerForKey:@"code"];
                
                if (statusCode==100) {
                    if (![url isEqualToString:[NSString stringWithFormat:@"%@%@",APPHOSTURL,logout]]) {
                        //会话过期，需要重连
                        [self connectToLogin];
                    }
                }else{
                    
                    success ? success(responseObject) : nil;
                    
                    //对数据进行异步缓存
                    responseCache ? [XWNetworkCache setHttpCache:responseObject URL:url parameters:params] : nil;
                    
                }
                
            }
            
            if (responseType==DATA) {
                
                success ? success(responseObject) : nil;
                
                //对数据进行异步缓存
                responseCache ? [XWNetworkCache setHttpCache:responseObject URL:url parameters:params] : nil;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES&&[self isHaveNetwork]==YES) {
                
                [MBProgressHUD hiddenHUD];
                
            }
            
            fail ? fail(error) : nil;
            
        }];
        
    }else if (type== POST){
        
        sessionTask = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[self tasks] removeObject:sessionTask];
            
            if (showHUD==YES&&[self isHaveNetwork]==YES) {
                
                [MBProgressHUD hiddenHUD];
                
            }
            
            if ([responseObject isKindOfClass:[NSDictionary class]]&&[[responseObject allKeys] containsObject:@"code"]) {
                
                NSInteger statusCode=[responseObject integerForKey:@"code"];
                
                if (statusCode==100) {
                    if (![url isEqualToString:[NSString stringWithFormat:@"%@%@",APPHOSTURL,logout]]) {
                        //会话过期，需要重连
                        [self connectToLogin];
                    }
                }else{
                    
                    success ? success(responseObject) : nil;
                    
                    //对数据进行异步缓存
                    responseCache ? [XWNetworkCache setHttpCache:responseObject URL:url parameters:params] : nil;
                    
                }
                
            }
            
            if (responseType==DATA) {
                
                success ? success(responseObject) : nil;
                
                //对数据进行异步缓存
                responseCache ? [XWNetworkCache setHttpCache:responseObject URL:url parameters:params] : nil;
            }
             
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[self tasks] removeObject:sessionTask];
            
            NSLog(@"错误原因:%@",error.description);
            
            if (showHUD==YES&&[self isHaveNetwork]==YES) {
                
                [MBProgressHUD hiddenHUD];
                
            }
            
            fail ? fail(error) : nil;
         
        }];
        
    }
    
    sessionTask?[[self tasks] addObject:sessionTask]:nil;
    
   return sessionTask;
}


/**
 *  会话过期重新登陆
 */
+ (void)connectToLogin{
    [UserDefaults setObject:nil forKey:TOKENID];
    [UserDefaults setInteger:0 forKey:USERID];
    [UserDefaults setObject:nil forKey:USER];
    [UserDefaults synchronize];
    [XWNetworkCache removeAllHttpCache];
    
    UIViewController *rootViewController = [[QMYBLoginViewController alloc]init];
    KeyWindow.rootViewController=rootViewController;
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提醒" message:@"系统检测到您的账户在新的设备上登陆，请重新登陆" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
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
        
        [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        
    }else{
        
        if (showHUD == YES) {
            
            [MBProgressHUD showHUDWithTitle:@"正在上传..."];
        }
    }
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    //[self sharedAFManager];
    
    [manager.requestSerializer setValue:[UserDefaults objectForKey:TOKENID] forHTTPHeaderField:TOKENID];
    
    [manager.requestSerializer setValue:[[UserDefaults objectForKey:USERID] stringValue] forHTTPHeaderField:USERID];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithArray:@[@"application/json", @"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
    
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
        
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            progress ? progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount) : nil;
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self tasks] removeObject:sessionTask];
        
        if (showHUD==YES&&[self isHaveNetwork]==YES) {
            
            [MBProgressHUD hiddenHUD];
        }
        
        if ([responseObject isKindOfClass:[NSDictionary class]]&&[[responseObject allKeys] containsObject:@"code"]) {
            
            NSInteger statusCode=[responseObject integerForKey:@"code"];
            
            if (statusCode==100) {
                if (![url isEqualToString:[NSString stringWithFormat:@"%@%@",APPHOSTURL,logout]]) {
                    //会话过期，需要重连
                    [self connectToLogin];
                }
                
            }else{
                
                success ? success(responseObject) : nil;
                
            }
            
        }
        
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         [[self tasks] removeObject:sessionTask];
        
        if (showHUD==YES&&[self isHaveNetwork]==YES) {
            
            [MBProgressHUD hiddenHUD];
        }
        
        fail ? fail(error) : nil;
        
     }];
    
    sessionTask?[[self tasks] addObject:sessionTask]:nil;
    
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
    
    //没有网络
    if ([self isHaveNetwork]==NO) {
        
        [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        
    }else{
        
        if (showHUD == YES) {
            
            [MBProgressHUD showHUDWithTitle:@"正在下载..."];
        }
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //[self sharedAFManager];
    
    [manager.requestSerializer setValue:[UserDefaults objectForKey:TOKENID] forHTTPHeaderField:TOKENID];
    
    [manager.requestSerializer setValue:[[UserDefaults objectForKey:USERID] stringValue] forHTTPHeaderField:USERID];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithArray:@[@"application/json", @"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];

    XWURLSessionTask *sessionTask = nil;
    
    sessionTask = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%.1f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            progressBlock ? progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount) : nil;
            
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:saveToPath ? saveToPath : @"Download"];
        
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (showHUD==YES&&[self isHaveNetwork]==YES) {
            
            [MBProgressHUD hiddenHUD];
        }
        
        [[self tasks] removeObject:sessionTask];
        
        if(fail && error) {
            
            fail(error);
            
            return ;
        };
        
        success ? success(filePath.absoluteString) : nil;
        
     }];
    
    //开始下载
    [sessionTask resume];

    // 添加sessionTask到数组
    sessionTask ? [[self tasks] addObject:sessionTask] : nil ;
    
    return sessionTask;
};


/**
 *  获取AFManager
 */
//+ (AFHTTPSessionManager *)sharedAFManager{
//    if (!manager) {
//       static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
//            manager = [AFHTTPSessionManager manager];
//            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//            manager.requestSerializer.timeoutInterval = 30;
//            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
//            [manager.requestSerializer setValue:VERSION forHTTPHeaderField:@"CL-app-v"];
//            [manager.requestSerializer setValue:zhengShiCeShi forHTTPHeaderField:@"CL-app-m"];
//            [manager.requestSerializer setValue:MYUUID forHTTPHeaderField:@"uuid"];
//        });
//    }
//    return manager;
//}

/**
 *  字符编码转换
 */
+ (NSString *)strUTF8Encoding:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
