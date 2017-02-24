//
//  QMYBMeViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBMeViewController.h"
#import "QMYBTestViewController.h"
#import "QMYBTuijianZhuceViewController.h"
#import "QMYBDianyuanListViewController.h"
#import "QMYBZhanghujiluController.h"

@interface QMYBMeViewController ()

@end

@implementation QMYBMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self initUI];
}

- (void)initUI{
    UIScrollView *myScroolerView=[[UIScrollView alloc]init];
    myScroolerView.showsVerticalScrollIndicator=NO;
    myScroolerView.showsHorizontalScrollIndicator=NO;
    myScroolerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myScroolerView];
    [myScroolerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [myScroolerView.mj_header endRefreshing];
            [myScroolerView.mj_footer endRefreshing];
            
        });
    }];
    myScroolerView.mj_header=mjHeader;
    
    UIView *contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor clearColor];
    [myScroolerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(myScroolerView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIImageView *topBG=[[UIImageView alloc]init];
    topBG.image=[UIImage imageNamed:@"渐变"];
    [contentView addSubview:topBG];
    [topBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(SCREEN_WIDTH*445/750.0);
    }];
    
    UILabel *me=[UILabel labelWithTitle:@"个人中心" color:[UIColor whiteColor] font:SystemFont(18)];
    [topBG addSubview:me];
    [me mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(topBG);
        make.top.mas_equalTo(topBG).offset(33);
    }];
    
    UIImageView *touxiang=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"形状-20"]];
    [topBG addSubview:touxiang];
    [touxiang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(topBG.mas_centerX);
        make.height.width.mas_equalTo(GetHeight(80));
        make.top.mas_equalTo(topBG).mas_equalTo(GetHeight(79));
    }];
    
    UILabel *weijiahuiyuan=[UILabel labelWithTitle:@"唯家会员" color:[UIColor whiteColor] font:font17];
    [topBG addSubview:weijiahuiyuan];
    [weijiahuiyuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(topBG);
        make.top.mas_equalTo(topBG).offset(GetHeight(174));
    }];
    
    UILabel *bianhao=[UILabel labelWithTitle:@"ID:15424354323" color:[UIColor whiteColor] font:font13];
    [topBG addSubview:bianhao];
    [bianhao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(topBG);
        make.top.mas_equalTo(topBG).offset(GetHeight(198));
    }];
    
    
    UIView *middleview=[[UIView alloc]init];
    middleview.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:middleview];
    [middleview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBG.mas_bottom);
        make.left.right.mas_equalTo(self.view);
    }];
    
    UILabel *tuiguanfei=[UILabel labelWithTitle:@"推广费" color:color595959 font:font16];
    [middleview addSubview:tuiguanfei];
    [tuiguanfei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetWidth(15));
        make.top.mas_equalTo(middleview).offset(GetHeight(13));
    }];
    
    UILabel *tixianjiane=[UILabel labelWithTitle:@"100000.00元" color:colorf28300 font:font25];
    [middleview addSubview:tixianjiane];
    [tixianjiane mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetWidth(15));
        make.top.mas_equalTo(tuiguanfei.mas_bottom).offset(GetHeight(13));
    }];
    
    UILabel *ketixianjiane=[UILabel labelWithTitle:@"可提现金额为5000.00元" color:color787878 font:font14];
    [middleview addSubview:ketixianjiane];
    [ketixianjiane mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetWidth(15));
        make.top.mas_equalTo(tixianjiane.mas_bottom).offset(GetHeight(13));
    }];
    
    UIView *bottonLine=[[UIView alloc]init];
    bottonLine.backgroundColor=colorc3c3c3;
    [middleview addSubview:bottonLine];
    [bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ketixianjiane.mas_bottom).offset(15);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    
    
    UIButton *zhanghujilu=[UIButton buttonWithTitle:@"账户记录" titleColor:color0086ff font:font15 target:self action:@selector(zhuanghujilu:)];
    [middleview addSubview:zhanghujilu];
    [zhanghujilu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-GetWidth(15));
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(ketixianjiane.mas_centerY);
    }];
    
    
    UIButton *tixian=[UIButton buttonWithTitle:@"提现" titleColor:color0086ff font:font15 target:self action:@selector(tixian:)];
    [tixian setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [middleview addSubview:tixian];
    [tixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(zhanghujilu.mas_left).offset(-GetWidth(15));
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(ketixianjiane.mas_centerY);
    }];
    
    
    [middleview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottonLine.mas_bottom);
    }];
    
    
    UIView *todayview=[[UIView alloc]init];
    todayview.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:todayview];
    [todayview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleview.mas_bottom).offset(GetHeight(10));
        make.left.right.mas_equalTo(self.view);
    }];
    
    UIView *todayLineup=[[UIView alloc]init];
    todayLineup.backgroundColor=colorc3c3c3;
    [todayview addSubview:todayLineup];
    [todayLineup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(todayview);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *jinrishouyi=[UILabel labelWithTitle:@"今日收益" color:color595959 font:font16];
    [todayview addSubview:jinrishouyi];
    [jinrishouyi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetWidth(15));
        make.top.mas_equalTo(todayLineup).offset(GetHeight(13));
    }];
    
    UILabel *jinrishouyie=[UILabel labelWithTitle:@"100000.00元" color:colorf28300 font:font25];
    [todayview addSubview:jinrishouyie];
    [jinrishouyie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetWidth(15));
        make.top.mas_equalTo(jinrishouyi.mas_bottom).offset(GetHeight(13));
    }];
    
    UIView *todayLinebottom=[[UIView alloc]init];
    todayLinebottom.backgroundColor=colorc3c3c3;
    [todayview addSubview:todayLinebottom];
    [todayLinebottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jinrishouyie.mas_bottom).offset(GetHeight(13));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    [todayview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(todayLinebottom.mas_bottom);
    }];
    
    
    
    UIView *guanli=[self getButtonView:@"电源管理" titleStr:@"店员管理" buttonTage:100];
    [contentView addSubview:guanli];
    [guanli mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(todayview.mas_bottom).offset(GetHeight(10));
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(GetHeight(50));
    }];
    
    UIView *tuijian=[self getButtonView:@"推荐注册" titleStr:@"推荐注册" buttonTage:101];
    [contentView addSubview:tuijian];
    [tuijian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(guanli.mas_bottom).offset(-0.5);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(GetHeight(50));
    }];
    
    UIView *set=[self getButtonView:@"安全设置" titleStr:@"安全设置" buttonTage:102];
    [contentView addSubview:set];
    [set mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tuijian.mas_bottom).offset(-0.5);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(GetHeight(50));
    }];
    
    
    
    NSString *str =@"店员";
    if (![str isEqualToString:@"店员"]) {
        [guanli removeFromSuperview];
        guanli=nil;
        
        [tuijian removeFromSuperview];
        tuijian=nil;
        
        [set mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(todayview.mas_bottom).offset(GetHeight(10));
        }];
        
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(set.mas_bottom).offset(GetHeight(15)+2*GetHeight(50));
        }];
    }else{
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(set.mas_bottom).offset(GetHeight(15));
        }];
    }
}


- (UIView *)getButtonView:(NSString *)imageName titleStr:(NSString *)str buttonTage:(NSInteger)buttonTage{
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=[UIColor whiteColor];
    
    UIView *topline=[[UIView alloc]init];
    topline.backgroundColor=colorc3c3c3;
    [bottomView addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView);
        make.left.right.mas_equalTo(bottomView);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *underline=[[UIView alloc]init];
    underline.backgroundColor=colorc3c3c3;
    [bottomView addSubview:underline];
    [underline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomView.mas_bottom);
        make.left.right.mas_equalTo(bottomView);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *button=[[UIButton alloc]init];
    [button setTitle:str forState:0];
    [button.titleLabel setFont:font16];
    button.tag=buttonTage;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setTitleColor:color595959 forState:0];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topline.mas_bottom);
        make.bottom.mas_equalTo(underline.mas_top);
        make.right.mas_equalTo(bottomView.mas_right);
        make.left.mas_equalTo(bottomView).offset(GetWidth(15)*2+GetWidth(30));
    }];
    
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:imageName];
    [bottomView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetWidth(15));
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.width.mas_equalTo(GetWidth(30));
    }];
    
    UIImageView *rightArr=[[UIImageView alloc]init];
    rightArr.image=[UIImage imageNamed:@"forward"];
    [bottomView addSubview:rightArr];
    [rightArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView.mas_right).offset(-GetWidth(15));
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.width.mas_equalTo(GetWidth(20));
    }];
    
    return bottomView;
}

//账户记录
- (void)zhuanghujilu:(UIButton *)sender{
    QMYBZhanghujiluController *jilu=[[QMYBZhanghujiluController alloc]init];
    jilu.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:jilu animated:YES];
}

//提现
- (void)tixian:(UIButton *)sender{
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.tag==100) {
        QMYBDianyuanListViewController *list=[[QMYBDianyuanListViewController alloc]init];
        list.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:list animated:YES];
    }else if (sender.tag==101) {
        QMYBTuijianZhuceViewController *tuijian=[[QMYBTuijianZhuceViewController alloc]init];
        tuijian.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:tuijian animated:YES];
    }else if (sender.tag==102) {
        NSLog(@"安全设置");
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
