//
//  QMYBTuijianZhuceViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/24.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBTuijianZhuceViewController.h"

@interface QMYBTuijianZhuceViewController (){
    UIImageView *erweima;
}

@end

@implementation QMYBTuijianZhuceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"推荐注册"];
    [self addLeftButton];
    self.view.layer.contents=(id)[UIImage imageNamed:@"bg-"].CGImage;
    
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    view.layer.cornerRadius=1;
    view.borderColor=[UIColor colorWithWhite:1 alpha:0.5];
    view.borderWidth=1;
    view.clipsToBounds=YES;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.width.mas_equalTo(GetWidth(180));
        make.top.mas_equalTo(GetHeight(195));
    }];
    
    erweima=[[UIImageView alloc]init];
    [view addSubview:erweima];
    [erweima mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(view).offset(3);
        make.right.bottom.mas_equalTo(view).offset(-3);
    }];
    
    UIImageView *tishi=[[UIImageView alloc]init];
    tishi.image=[UIImage imageNamed:@"提示文字"];
    [self.view addSubview:tishi];
    [tishi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).offset(GetHeight(40));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(GetWidth(178));
        make.height.mas_equalTo(GetWidth(178)*56/356.0);
    }];
    
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,registerPage];
    [XWNetworking getJsonWithUrl:url params:nil responseCache:^(id responseCache) {
        if ([self isNetworkRunning]==NO) {
            [self saveData:responseCache];
        }
    } success:^(id response) {
        [self saveData:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"刷新二维码失败"];
    } showHud:YES];
    
}

#pragma mark 保存更新用户数据
- (void)saveData:(id)response{
    NSLog(@"===%@",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else{
            NSString *urlStr=[response stringForKey:@"data"];
            [erweima sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"空白图"]];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
