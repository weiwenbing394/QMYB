//
//  QMYBTixianViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBTixianViewController.h"
#import "User.h"
#import "TixianView.h"

@interface QMYBTixianViewController ()<UITextFieldDelegate>{
    User *user;
    UITextField *jine;
    UIButton *tixian;
}

@property (nonatomic,strong)JCAlertView *tixianAlert;

@end

@implementation QMYBTixianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"收益转出（提现）"];
    [self addLeftButton];
    user=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults objectForKey:USER] ];
    [self initUI];
}

//页面布局
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
    
    
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor whiteColor];
    headView.layer.borderColor=colorc3c3c3.CGColor;
    headView.layer.borderWidth=0.5;
    [contentView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(GetWidth(15));
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(15));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(15));
        make.height.mas_equalTo(GetHeight(65));
    }];
    
    UILabel *zhuanrudao=[[UILabel alloc]init];
    zhuanrudao.text=@"转入到";
    zhuanrudao.textColor=[UIColor whiteColor];
    zhuanrudao.font=font15;
    zhuanrudao.textAlignment=NSTextAlignmentCenter;
    zhuanrudao.backgroundColor=color0086ff;
    [headView addSubview:zhuanrudao];
    [zhuanrudao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(headView);
        make.height.width.mas_equalTo(headView.mas_height);
    }];
    
    UILabel *userName=[[UILabel alloc]init];
    userName.text=user.businessName?user.businessName:@"";
    userName.textColor=color595959;
    userName.font=font15;
    [headView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView).mas_equalTo(GetWidth(10));
        make.left.mas_equalTo(zhuanrudao.mas_right).offset(GetWidth(15));
    }];
    
    UILabel *bankName=[[UILabel alloc]init];
    bankName.text=user.bankName?user.bankName:@"";
    bankName.textColor=color787878;
    bankName.font=font14;
    [headView addSubview:bankName];
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userName.mas_right).mas_equalTo(GetWidth(15));
        make.right.mas_equalTo(headView.mas_right).mas_equalTo(-GetWidth(15));
        make.centerY.mas_equalTo(userName.mas_centerY);
    }];
    
    UILabel *bankNumber=[[UILabel alloc]init];
    bankNumber.text=[NSString stringWithFormat:@"%@",user.bankId].length>5?[self BankNum:user.bankId]:[NSString stringWithFormat:@"%@",user.bankId];
    bankNumber.textColor=[UIColor blackColor];
    bankNumber.font=font15;
    [headView addSubview:bankNumber];
    [bankNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userName.mas_left);
        make.right.mas_equalTo(headView.mas_right).mas_equalTo(-GetWidth(15));
        make.bottom.mas_equalTo(headView.mas_bottom).offset(-GetWidth(7));;
    }];
    
    
    UIView *lineUP=[[UIView alloc]init];
    lineUP.backgroundColor=colorc3c3c3;
    [contentView addSubview:lineUP];
    [lineUP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).offset(GetWidth(15));
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
    
    UILabel *tixianjine=[[UILabel alloc]init];
    tixianjine.text=@"提现金额";
    tixianjine.textColor=color595959;
    tixianjine.font=font15;
    [whiteBg addSubview:tixianjine];
    [tixianjine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteBg.mas_left).offset(GetWidth(15));
        make.top.mas_equalTo(whiteBg);
        make.height.mas_equalTo(whiteBg);
    }];
    
    jine=[[UITextField alloc]init];
    jine.tintColor=[UIColor darkGrayColor];
    jine.placeholder=[NSString stringWithFormat:@"本次最多提现%.2f",user.withdrawAmt];
    jine.clearButtonMode=UITextFieldViewModeWhileEditing;
    jine.keyboardType=UIKeyboardTypeDecimalPad;
    jine.textColor=color787878;
    jine.font=font15;
    jine.delegate=self;
    jine.textAlignment=NSTextAlignmentRight;
    [jine addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [whiteBg addSubview:jine];
    [jine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tixianjine.mas_right).offset(GetWidth(15));
        make.right.mas_equalTo(whiteBg.mas_right).offset(-GetWidth(15));;
        make.height.mas_equalTo(whiteBg);
        make.top.mas_equalTo(tixianjine);
    }];
    
    UIView *lineBottom=[[UIView alloc]init];
    lineBottom.backgroundColor=colorc3c3c3;
    [contentView addSubview:lineBottom];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(whiteBg.mas_bottom);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *shuoming=[[UILabel alloc]init];
    shuoming.text=@"每笔限额10,000元；预计3个工作日内到账（工作日）。";
    shuoming.textColor=color787878;
    shuoming.font=font13;
    shuoming.numberOfLines=0;
    shuoming.textAlignment=NSTextAlignmentLeft;
    [contentView addSubview:shuoming];
    [shuoming mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(15));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(15));;
        make.top.mas_equalTo(lineBottom.mas_bottom).offset(GetHeight(15));;
    }];
    
    
    tixian=[UIButton buttonWithTitle:@"提现" titleColor:[UIColor whiteColor] font:font17 target:self action:@selector(tixian:)];
    tixian.enabled=NO;
    [tixian setBackgroundImage:[UIImage imageNamed:@"btnormal"] forState:0];
    [tixian setBackgroundImage:[UIImage imageNamed:@"btforbidden"] forState:UIControlStateDisabled];
    [tixian setBackgroundImage:[UIImage imageNamed:@"btclick"] forState:UIControlStateHighlighted];
    [contentView addSubview:tixian];
    [tixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shuoming.mas_bottom).offset(GetHeight(170));
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(50));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(50));
        make.height.mas_equalTo(GetHeight(40));
    }];
    
    
    UIButton  *shui=[[UIButton alloc]init];
    [shui setTitle:@"查看缴税规则" forState:0];
    [shui setTitleColor:color0086ff forState:0];
    [shui setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [shui.titleLabel setFont:font15];
    [shui addTarget:self action:@selector(lookShui:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:shui];
    [shui mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(tixian.mas_bottom).offset(GetHeight(150));;
    }];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(shui.mas_bottom).offset(GetHeight(30));
    }];
}


//提现
- (void)tixian:(UIButton *)sender{
    if ([jine.text floatValue]>user.withdrawAmt) {
        [MBProgressHUD showError:@"余额不足"];
        return;
    }
    if ([jine.text floatValue]<=0) {
        [MBProgressHUD showError:@"提现金额不能为0"];
        return;
    }
    if ([jine.text floatValue]>10000) {
        [MBProgressHUD showError:@"提现金额超过单笔限定额度"];
        return;
    }
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,withDraw];
    NSString *tixianjine=[NSString stringWithFormat:@"%.2f",[jine.text floatValue]];
    NSDictionary *dic=@{@"withDrawAmount":@([tixianjine floatValue])};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        [self saveData:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"系统繁忙"];
    } showHud:YES];
}


#pragma mark 保存更新用户数据
- (void)saveData:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else if(statusCode==1){
            [MBProgressHUD showSuccess:@"提现申请已请求成功"];
            //总金额
            user.accountAmt=[response[@"data"] floatForKey:@"accountAmt"];
            //可提现
            user.withdrawAmt=[response[@"data"] floatForKey:@"withdrawAmt"];
            
            NSData *userData=[NSKeyedArchiver archivedDataWithRootObject:user];
            [UserDefaults setObject:userData forKey:USER];
            [UserDefaults synchronize];
            jine.text=@"";
            jine.placeholder=[NSString stringWithFormat:@"本次最多提现%.2f",user.withdrawAmt];
        }
    }
}

/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if (jine == textField) {
        tixian.enabled = (textField.text.length &&[textField.text floatValue]>0);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == jine) {
        //如果输入的是“.”  判断之前已经有"."或者字符串为空
        if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])) {
            return NO;
        }
        //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
        NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
        [str insertString:string atIndex:range.location];
        if (str.length >= [str rangeOfString:@"."].location+4){
            return NO;
        }
    }
    return YES;
}

- (void)lookShui:(UIButton *)sender{
    WeakSelf;
    TixianView *tixianView=[[TixianView alloc]initWithFrame:CGRectMake(0, 0, GetWidth(308), GetWidth(268)+65) withImageUrlStr:nil];
    tixianView.cancelBlock=^(){
        [weakSelf.tixianAlert dismissWithCompletion:nil];
    };
    weakSelf.tixianAlert=[[JCAlertView alloc]initWithCustomView:tixianView dismissWhenTouchedBackground:NO];
    [weakSelf.tixianAlert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
