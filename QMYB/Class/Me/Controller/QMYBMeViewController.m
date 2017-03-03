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
#import "QMYBTixianViewController.h"
#import "QMYBAnquanViewController.h"
#import "User.h"
#import "QMYBBankRegisteViewController.h"

@interface QMYBMeViewController (){
    UIScrollView *myScroolerView;
    UILabel *bianhao;
    UILabel *tixianjiane;
    UILabel *ketixianjiane;
    UILabel *jinrishouyie;
    UIView *contentView;
    UIView *guanli;
    UIView *tuijian;
    UIView *set;
    UIView *todayview;
}

@end

@implementation QMYBMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self initUI];
    [myScroolerView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
    User  *user=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults objectForKey:USER]];
    //推广费
    NSString *tixianNumber=[NSString stringWithFormat:@"%.2f元",user.accountAmt];
    NSMutableAttributedString *att=[[NSMutableAttributedString alloc]initWithString:tixianNumber];
    [att addAttribute:NSFontAttributeName value:font25 range:NSMakeRange(0, tixianNumber.length)];
    [att addAttribute:NSFontAttributeName value:font13 range:NSMakeRange(tixianNumber.length-1, 1)];
    [tixianjiane setAttributedText:att];
    
    //可提现金额
    NSString *ketixianStr=[NSString stringWithFormat:@"可提现金额为%.2f元",user.withdrawAmt];
    ketixianjiane.text=ketixianStr;
}

#pragma mark 保存更新用户数据
- (void)saveData:(id)response{
    NSLog(@"%@==",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else{
            NSString *tokenID=response[@"tokenId"]!=[NSNull null]?response[@"tokenId"]:@"";
            NSInteger userId=[response[@"data"] integerForKey:@"userId"];
            User *user=[User mj_objectWithKeyValues:response[@"data"]];
            NSData *userData=[NSKeyedArchiver archivedDataWithRootObject:user];
            [UserDefaults setObject:tokenID forKey:TOKENID ];
            [UserDefaults setInteger:userId forKey:USERID];
            [UserDefaults setObject:userData forKey:USER];
            [UserDefaults synchronize];
            
            //推广费
            NSString *tixianNumber=[NSString stringWithFormat:@"%.2f元",user.accountAmt];
            NSMutableAttributedString *att=[[NSMutableAttributedString alloc]initWithString:tixianNumber];
            [att addAttribute:NSFontAttributeName value:font25 range:NSMakeRange(0, tixianNumber.length)];
            [att addAttribute:NSFontAttributeName value:font13 range:NSMakeRange(tixianNumber.length-1, 1)];
            [tixianjiane setAttributedText:att];
            
            //可提现金额
            NSString *ketixianStr=[NSString stringWithFormat:@"可提现金额为%.2f元",user.withdrawAmt];
            ketixianjiane.text=ketixianStr;
            
            //今日收益
            NSString *todayshouyi=[NSString stringWithFormat:@"%.2f元",user.dayCommission];
            NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:todayshouyi];
            [attr addAttribute:NSFontAttributeName value:font25 range:NSMakeRange(0, todayshouyi.length)];
            [attr addAttribute:NSFontAttributeName value:font13 range:NSMakeRange(todayshouyi.length-1, 1)];
            [jinrishouyie setAttributedText:attr];
            
            //更新视图
            if (user.level==5) {
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
    }
}


- (void)initUI{
    
    myScroolerView=[[UIScrollView alloc]init];
    myScroolerView.showsVerticalScrollIndicator=NO;
    myScroolerView.showsHorizontalScrollIndicator=NO;
    myScroolerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myScroolerView];
    
    [myScroolerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,updateUserInfo];
        User  *user=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults objectForKey:USER] ];
        NSDictionary *dic=@{@"phone":user.phone};
        [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
            [myScroolerView.mj_header endRefreshing];
            [self saveData:response];
        } fail:^(NSError *error) {
            [MBProgressHUD showError:@"获取个人信息失败"];
            [myScroolerView.mj_header endRefreshing];
        } showHud:NO];
    }];
    myScroolerView.mj_header=mjHeader;
    
    contentView=[[UIView alloc]init];
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
    
    UIImageView *touxiang=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login-logo"]];
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
    
    User  *user=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults objectForKey:USER] ];
    
    NSString *bianhaoStr=[NSString stringWithFormat:@"ID:%@",user.accountCode];
    bianhao=[UILabel labelWithTitle:bianhaoStr color:[UIColor whiteColor] font:font13];
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
    
    NSString *tixianNumber=[NSString stringWithFormat:@"%.2f元",user.accountAmt];
    tixianjiane=[UILabel labelWithTitle:tixianNumber color:colorf28300 font:font25];
    NSMutableAttributedString *att=[[NSMutableAttributedString alloc]initWithString:tixianNumber];
    [att addAttribute:NSFontAttributeName value:font25 range:NSMakeRange(0, tixianNumber.length)];
    [att addAttribute:NSFontAttributeName value:font13 range:NSMakeRange(tixianNumber.length-1, 1)];
    [tixianjiane setAttributedText:att];
    [middleview addSubview:tixianjiane];
    [tixianjiane mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetWidth(15));
        make.top.mas_equalTo(tuiguanfei.mas_bottom).offset(GetHeight(13));
    }];
    
    NSString *ketixianStr=[NSString stringWithFormat:@"可提现金额为%.2f元",user.withdrawAmt];
    ketixianjiane=[UILabel labelWithTitle:ketixianStr color:color787878 font:font14];
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
    
    
    todayview=[[UIView alloc]init];
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
    
    NSString *todayshouyi=[NSString stringWithFormat:@"%.2f元",user.dayCommission];
    jinrishouyie=[UILabel labelWithTitle:todayshouyi color:colorf28300 font:font25];
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:todayshouyi];
    [attr addAttribute:NSFontAttributeName value:font25 range:NSMakeRange(0, todayshouyi.length)];
    [attr addAttribute:NSFontAttributeName value:font13 range:NSMakeRange(todayshouyi.length-1, 1)];
    [jinrishouyie setAttributedText:attr];
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
    
    
    
    guanli=[self getButtonView:@"电源管理" titleStr:@"店员管理" buttonTage:100];
    [contentView addSubview:guanli];
    [guanli mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(todayview.mas_bottom).offset(GetHeight(10));
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(GetHeight(50));
    }];
    
    tuijian=[self getButtonView:@"推荐注册" titleStr:@"推荐注册" buttonTage:101];
    [contentView addSubview:tuijian];
    [tuijian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(guanli.mas_bottom).offset(-0.5);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(GetHeight(50));
    }];
    
    set=[self getButtonView:@"安全设置" titleStr:@"安全设置" buttonTage:102];
    [contentView addSubview:set];
    [set mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tuijian.mas_bottom).offset(-0.5);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(GetHeight(50));
    }];
    
    if (user.level==5) {
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
    User  *user=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults objectForKey:USER]];
    if (0<[self clearSpace:user.bankId].length) {
        QMYBTixianViewController *tixian=[[QMYBTixianViewController alloc]init];
        tixian.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:tixian animated:YES];
    }else{
        QMYBBankRegisteViewController *Bankregister=[[QMYBBankRegisteViewController alloc] init];
        Bankregister.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:Bankregister animated:YES];
        [MBProgressHUD ToastInformation:@"请先绑定提现银行卡"];
    }
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.tag==100) {
        QMYBDianyuanListViewController *listController=[[QMYBDianyuanListViewController alloc]init];
        listController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:listController animated:YES];
    }else if (sender.tag==101) {
        QMYBTuijianZhuceViewController *tuijianController=[[QMYBTuijianZhuceViewController alloc]init];
        tuijianController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:tuijianController animated:YES];
    }else if (sender.tag==102) {
        QMYBAnquanViewController *anquanController=[[QMYBAnquanViewController alloc]init];
        anquanController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:anquanController animated:YES];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
};


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
