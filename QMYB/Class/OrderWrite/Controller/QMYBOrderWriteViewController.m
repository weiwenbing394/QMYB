//
//  QMYBOrderWriteViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBOrderWriteViewController.h"

@interface QMYBOrderWriteViewController ()

@end

@implementation QMYBOrderWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"录单"];
    
    NSLog(@"网络缓存大小cache = %.02fMB",[XWNetworkCache getAllHttpCacheSize]/1024/1024.f);
    
    UIImageView *testImage=[[UIImageView alloc]init];
    testImage.tag=100;
    testImage.backgroundColor=[UIColor blueColor];
    [self.view addSubview:testImage];
    testImage.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(200);
    
    UIImageView *imageView=[self.view viewWithTag:100];
    [XWNetworking getWithUrlAndResponseData:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487673540706&di=9d3947edaabca68e357f5e8a6d539908&imgtype=0&src=http%3A%2F%2Fimg0.ph.126.net%2Fa1t62bWdJandvL5V-7DNkw%3D%3D%2F6608431020306209871.jpg" params:nil responseCache:^(id responseCache) {
            imageView.image=[UIImage imageWithData:responseCache];
    } success:^(id response) {
        imageView.image=[UIImage imageWithData:response];
    } fail:^(NSError *error) {
        NSLog(@"请求发生错误");
    } showHud:YES];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 215, SCREEN_WIDTH, 50)];
    [button setTitle:@"清除缓存" forState:0];
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:self action:@selector(cleanCache) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)cleanCache{
    [XWNetworkCache removeAllHttpCache];
    NSLog(@"网络缓存大小cache = %.02fMB",[XWNetworkCache getAllHttpCacheSize]/1024/1024.f);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
