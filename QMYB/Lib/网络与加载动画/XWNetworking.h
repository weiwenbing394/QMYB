//
//  XWPNetworking.h
//  XW_MB_AF_MANAGER
//
//  Created by 大家保 on 2016/10/19.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

/**
 *  手机网络状态
 */
typedef enum{
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
}NetworkStatu;

/**
 *  请求方式 GET OR POST
 */
typedef enum HttpMethod {
    /** 设置请求方式 GET*/
    GET,
    /** 设置请求方式 POST*/
    POST
} httpMethod;

/**
 *  服务器返回数据 JSON OR DATA
 */
typedef enum ResponseType {
    /** 设置响应数据为JSON格式*/
    JSON,
    /** 设置响应数据为二进制格式*/
    DATA
} responseType;

/** 请求成功的Block */
typedef void( ^ XWResponseSuccess)(id response);
/** 请求失败的Block */
typedef void( ^ XWResponseFail)(NSError *error);
/** 缓存的Block */
typedef void(^XWHttpRequestCache)(id responseCache);
/** 上传的进度*/
typedef void( ^ XWUploadProgress)(int64_t bytesProgress,int64_t totalBytesProgress);
/** 下载的进度*/
typedef void( ^ XWDownloadProgress)(int64_t bytesProgress,int64_t totalBytesProgress);
/** 网络状态的Block*/
typedef void(^XWNetworkStatus)(NetworkStatu status);

typedef NSURLSessionTask XWURLSessionTask;

@interface XWNetworking : NSObject

@property (nonatomic,assign)NetworkStatu networkStats;

/**
 *  单例
 */
+ (XWNetworking *)sharedXWNetworking;

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(XWNetworkStatus)networkStatus;

/**
 *  是否有网络连接
 */
+ (BOOL) isHaveNetwork;

/**
 取消所有HTTP请求
 */
+ (void)cancelAllRequest;

/**
 取消指定URL的HTTP请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;

#pragma mark 无缓存请求
/**
 *  Get请求,返回json,无缓存
 */
+ (XWURLSessionTask *)getJsonWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


/**
 *  POST请求,返回json,无缓存
 */
+ (XWURLSessionTask *)postJsonWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;

/**
 *  Get请求,返回data,无缓存
 */
+ (XWURLSessionTask *)getDataWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


/**
 *  POST请求,返回data,无缓存
 */
+ (XWURLSessionTask *)postDataWithUrl:(NSString *)url params:(NSDictionary *)params success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


#pragma mark 有缓存请求
/**
 *  Get请求,返回json,有缓存
 */
+ (XWURLSessionTask *)getJsonWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


/**
 *  POST请求,返回json,有缓存
 */
+ (XWURLSessionTask *)postJsonWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;

/**
 *  Get请求,返回data,有缓存
 */
+ (XWURLSessionTask *)getDataWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;


/**
 *  POST请求,返回data,有缓存
 */
+ (XWURLSessionTask *)postDataWithUrl:(NSString *)url params:(NSDictionary *)params responseCache:(XWHttpRequestCache)responseCache success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHud:(BOOL)showHUD;



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
+ (XWURLSessionTask *)uploadWithImages:(NSArray<UIImage *> *)imageArr url:(NSString *)url filename:(NSString *)filename names:(NSArray *)nameArr params:(NSDictionary *)params  progress:(XWUploadProgress)progress success:(XWResponseSuccess)success fail:(XWResponseFail)fail showHUD:(BOOL)showHUD;

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
+ (XWURLSessionTask *)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath  progress:(XWDownloadProgress )progressBlock  success:(XWResponseSuccess )success failure:(XWResponseFail )fail showHUD:(BOOL)showHUD;



@end
