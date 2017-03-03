//
//  QMYBAnquanViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBAnquanViewController.h"
#import "QMYBLoginViewController.h"
#import "QMYBBankRegisteViewController.h"
#import "QMYBBankChangeViewController.h"
#import "User.h"

@interface QMYBAnquanViewController (){
    User *user;
    UIButton *caozuo;
    UILabel *bankName;
}

@end

@implementation QMYBAnquanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"安全设置"];
    [self addLeftButton];
    user=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults objectForKey:USER]];
    [NotiCenter addObserver:self selector:@selector(changeBankID) name:@"changeBankID" object:nil];
    [self initUI];
}

- (void)changeBankID{
    User *user_new=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults objectForKey:USER]];
    if (0<user_new.bankId.length) {
        [caozuo setTitle:@"更换" forState:0];
    }else{
        [caozuo setTitle:@"绑定" forState:0];
    }
    if (user_new.bankId.length==0) {
        bankName.text=@"";
        return;
    }
    NSRange range=[user_new.bankName rangeOfString:@"·"];
    NSString *bankname;
    if (range.location != NSNotFound) {
        bankname=user_new.bankName.length>0?[user_new.bankName substringToIndex:range.location]:@"";
    }else{
        bankname=user_new.bankName.length>0?user_new.bankName:@"";
    }
    NSString *bankId=user_new.bankId.length>4?[user_new.bankId substringWithRange:NSMakeRange(user_new.bankId.length-4, 4)]:user_new.bankId;
    bankName.text=[NSString stringWithFormat:@"%@（%@）",bankname,bankId];
}

- (void)dealloc{
    [NotiCenter removeObserver:self];
}

- (void)initUI{
    UIScrollView *scrollerView=[[UIScrollView alloc]init];
    scrollerView.showsVerticalScrollIndicator=NO;
    scrollerView.showsHorizontalScrollIndicator=NO;
    scrollerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:scrollerView];
    [scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);;
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    
    UIView *contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor clearColor];
    [scrollerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollerView.mas_top);
        make.bottom.mas_equalTo(scrollerView.mas_bottom);
        make.left.mas_equalTo(scrollerView.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIView *lineUP=[[UIView alloc]init];
    lineUP.backgroundColor=colorc3c3c3;
    [contentView addSubview:lineUP];
    [lineUP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(GetWidth(15));
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *whiteBg=[[UIView alloc]init];
    whiteBg.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineUP.mas_bottom);
        make.left.right.mas_equalTo(lineUP);
        make.height.mas_equalTo(GetHeight(50));
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UILabel *phone=[[UILabel alloc]init];
    phone.text=@"手机号";
    phone.textColor=color595959;
    phone.font=font16;
    [whiteBg addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteBg.mas_left).offset(GetWidth(15));
        make.top.mas_equalTo(whiteBg);
        make.height.mas_equalTo(whiteBg);
    }];
    
    UILabel *phoneNum=[[UILabel alloc]init];
    phoneNum.text=7<user.phone.length?[self place:user.phone]:user.phone;
    phoneNum.textColor=[UIColor blackColor];
    phoneNum.font=font16;
    [whiteBg addSubview:phoneNum];
    [phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phone.mas_right).offset(GetWidth(45));
        make.height.mas_equalTo(whiteBg);
        make.top.mas_equalTo(phone);
    }];
    
    UILabel *status=[[UILabel alloc]init];
    status.text=@"已认证";
    status.textColor=color787878;
    status.font=font16;
    [whiteBg addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteBg.mas_right).offset(-GetWidth(15));
        make.height.mas_equalTo(whiteBg);
        make.top.mas_equalTo(phone);
    }];
    
    UIView *lineBottom=[[UIView alloc]init];
    lineBottom.backgroundColor=colorc3c3c3;
    [contentView addSubview:lineBottom];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(whiteBg.mas_bottom);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UIView *bankBG=[[UIView alloc]init];
    bankBG.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:bankBG];
    [bankBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineBottom.mas_bottom);
        make.left.right.mas_equalTo(lineBottom);
        make.height.mas_equalTo(GetHeight(50));
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UILabel *bank=[[UILabel alloc]init];
    bank.text=@"银行卡管理";
    bank.textColor=color595959;
    bank.font=font16;
    [bankBG addSubview:bank];
    [bank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankBG.mas_left).offset(GetWidth(15));
        make.top.mas_equalTo(bankBG);
        make.height.mas_equalTo(bankBG);
    }];
    
    bankName=[[UILabel alloc]init];
    if (user.bankId.length==0) {
        bankName.text=@"";
    }else{
        NSRange range=[user.bankName rangeOfString:@"·"];
        NSString *bankname;
        if (range.location != NSNotFound) {
            bankname=user.bankName.length>0?[user.bankName substringToIndex:range.location]:@"";
        }else{
            bankname=user.bankName.length>0?user.bankName:@"";
        }
        NSString *bankId=user.bankId.length>4?[user.bankId substringWithRange:NSMakeRange(user.bankId.length-4, 4)]:user.bankId;
        bankName.text=[NSString stringWithFormat:@"%@（%@）",bankname,bankId];
    }
    bankName.textColor=[UIColor blackColor];
    bankName.font=font16;
    [bankBG addSubview:bankName];
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneNum.mas_left);
        make.height.mas_equalTo(bankBG);
        make.top.mas_equalTo(bank);
    }];
    
    caozuo=[[UIButton alloc]init];
    if (0<user.bankId.length) {
        [caozuo setTitle:@"更换" forState:0];
    }else{
        [caozuo setTitle:@"绑定" forState:0];
    }
    [caozuo addTarget:self action:@selector(caozuo:) forControlEvents:UIControlEventTouchUpInside];
    [caozuo setTitleColor:color0086ff forState:0];
    [caozuo.titleLabel setFont:font16];
    [caozuo setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [bankBG addSubview:caozuo];
    [caozuo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bankBG.mas_right).offset(-GetWidth(15));
        make.height.mas_equalTo(bankBG);
        make.top.mas_equalTo(bankName);
        make.width.mas_equalTo(100);
    }];
    
    UIView *lineBottom2=[[UIView alloc]init];
    lineBottom2.backgroundColor=colorc3c3c3;
    [contentView addSubview:lineBottom2];
    [lineBottom2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bankBG.mas_bottom);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *exit=[UIButton buttonWithTitle:@"退出登录" titleColor:[UIColor whiteColor] font:font16 target:self action:@selector(exit:)];
    [exit setBackgroundImage:[UIImage imageNamed:@"btnormal"] forState:0];
    [exit setBackgroundImage:[UIImage imageNamed:@"btforbidden"] forState:UIControlStateDisabled];
    [exit setBackgroundImage:[UIImage imageNamed:@"btclick"] forState:UIControlStateHighlighted];
    [contentView addSubview:exit];
    [exit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineBottom2.mas_bottom).offset(GetHeight(100));
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(50));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(50));
        make.height.mas_equalTo(GetHeight(40));
    }];
    
    
    UIButton *callPhone=[UIButton buttonWithTitle:@"" titleColor:color0086ff font:font13 target:self action:@selector(callPhone:)];
    [callPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:@"客服电话 400 1114 567"];
    [attr addAttribute:NSForegroundColorAttributeName value:color0086ff range:NSMakeRange(0, @"客服电话 400 1114 567".length)];
    [attr addAttribute:NSForegroundColorAttributeName value:color595959 range:NSMakeRange(0, 4)];
    [callPhone setAttributedTitle:attr forState:0];
    [contentView addSubview:callPhone];
    [callPhone mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(exit.mas_bottom).offset(GetHeight(285));
        make.height.mas_equalTo(44);
    }];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(callPhone.mas_bottom).offset(GetHeight(30));
    }];


}

//退出
- (void)exit:(UIButton *)sender{
    UIAlertController *exitAlert=[UIAlertController alertControllerWithTitle:@"确定退出登录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *queding=[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDWithTitle:@"正在退出"];
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,logout];
        [XWNetworking getJsonWithUrl:url params:nil success:^(id response) {
            [self saveData:response];
            [MBProgressHUD hiddenHUD];
        } fail:^(NSError *error) {
            [MBProgressHUD showError:@"退出失败，请重试"];
        } showHud:NO];
    }];
    [exitAlert addAction:cancel];
    [exitAlert addAction:queding];
    [self presentViewController:exitAlert animated:YES completion:nil];
}

//解析退出数据
- (void)saveData:(id)response{
    NSLog(@"%@",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else{
            [UserDefaults setObject:nil forKey:TOKENID];
            [UserDefaults setInteger:0 forKey:USERID];
            [UserDefaults setObject:nil forKey:USER];
            [UserDefaults synchronize];
            [XWNetworkCache removeAllHttpCache];
            KeyWindow.rootViewController=[[QMYBLoginViewController alloc]init];
        }
    }

}

- (void)callPhone:(UIButton *)sender{
    UIAlertController *phoneAlert=[UIAlertController alertControllerWithTitle:@"确定拨打400-1114-567?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *queding=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url =[NSURL URLWithString:@"tel:4001114567"];
        [[UIApplication sharedApplication] openURL:url];
    }];
    [phoneAlert addAction:cancel];
    [phoneAlert addAction:queding];
    [self presentViewController:phoneAlert animated:YES completion:nil];
}


- (void)caozuo:(UIButton *)sender{
    if (0<user.bankId.length) {
        QMYBBankChangeViewController *change=[[QMYBBankChangeViewController alloc]init];
        change.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:change animated:YES];
    }else{
        QMYBBankRegisteViewController *BankRegiste=[[QMYBBankRegisteViewController alloc]init];
        BankRegiste.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:BankRegiste animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSString *)place:(NSString *)str{
    NSMutableString *cardIdStr=[[NSMutableString alloc]initWithString:str];
    for (int i=3; i<cardIdStr.length-4; i++) {
        [cardIdStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return cardIdStr;
}

@end
