//
//  QMYBBankRegisteViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBBankRegisteViewController.h"
#import "User.h"

@interface QMYBBankRegisteViewController ()<UITextFieldDelegate>{
    UITextField *bankField;
    UITextField *nameField;
    UITextField *kaihuhangField;
    UITextField *idcardField;
    UIButton *bangding;
    User  *user;
    NSString *bankName;
    UILabel  *bankNameLabel;
}

@end

@implementation QMYBBankRegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"绑定银行卡"];
    [self addLeftButton];
    bankName=@"";
    user=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults objectForKey:USER] ];
    [self initUI];
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
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    
    UIView *contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor clearColor];
    [scrollerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollerView.mas_top);
        make.bottom.mas_equalTo(scrollerView.mas_bottom);
        make.left.right.mas_equalTo(scrollerView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.right.mas_equalTo(scrollerView.mas_right);
    }];
    
    UIView *lineUP=[self getLineView];
    [contentView addSubview:lineUP];
    [lineUP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(GetWidth(15));
        make.left.right.mas_equalTo(contentView);
    }];
    
    UIView *whiteView=[self getWhiteView];
    [contentView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineUP.mas_bottom);
        make.left.right.mas_equalTo(lineUP);
        make.height.mas_equalTo(GetHeight(220));
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UILabel *bank=[self getBlackLabel:@"卡号"];
    [whiteView addSubview:bank];
    [bank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(whiteView);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(15));
        make.height.mas_equalTo(GetHeight(69.5));
    }];
    
    bankNameLabel=[[UILabel alloc]init];
    bankNameLabel.textColor=[UIColor redColor];
    bankNameLabel.font=font10;
    bankNameLabel.text=bankName;
    [whiteView addSubview:bankNameLabel];
    [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(whiteView.mas_top).offset(GetHeight(44));
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(80));
        make.right.mas_equalTo(whiteView.mas_right).offset(-GetWidth(15));
    }];
    
    
    bankField=[self getTextField:@"请输入正确的银行卡号"];
    bankField.delegate=self;
    bankField.keyboardType=UIKeyboardTypeNumberPad;
    [whiteView addSubview:bankField];
    [bankField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bank.mas_top);
        make.height.mas_equalTo(GetHeight(69.5));
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(80));
        make.right.mas_equalTo(whiteView.mas_right).offset(-GetWidth(15));
    }];
    
    UIView *nameLine=[self getLineView];
    [whiteView addSubview:nameLine];
    [nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bank.mas_bottom);
        make.right.mas_equalTo(whiteView);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(15));
    }];
    
    UILabel *userName=[self getBlackLabel:@"姓名"];
    [whiteView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLine);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(15));
        make.height.mas_equalTo(GetHeight(49.5));
    }];
    
    nameField=[self getTextField:@"请输入持卡人姓名"];
    nameField.userInteractionEnabled=NO;
    nameField.text=user.businessName;
    [whiteView addSubview:nameField];
    [nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userName.mas_top);
        make.height.mas_equalTo(userName);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(80));
        make.right.mas_equalTo(whiteView.mas_right).offset(-GetWidth(15));
    }];

    UIView *kaihuhangLine=[self getLineView];
    [whiteView addSubview:kaihuhangLine];
    [kaihuhangLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userName.mas_bottom);
        make.right.mas_equalTo(whiteView);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(15));
    }];
    
    UILabel *kaihuhang=[self getBlackLabel:@"开户行"];
    [whiteView addSubview:kaihuhang];
    [kaihuhang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kaihuhangLine);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(15));
        make.height.mas_equalTo(GetHeight(49.5));
    }];
    
    kaihuhangField=[self getTextField:@"请输入开户支行"];
    [whiteView addSubview:kaihuhangField];
    [kaihuhangField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kaihuhang.mas_top);
        make.height.mas_equalTo(kaihuhang);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(80));
        make.right.mas_equalTo(whiteView.mas_right).offset(-GetWidth(15));
    }];
    
    UIView *idcardLine=[self getLineView];
    [whiteView addSubview:idcardLine];
    [idcardLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kaihuhang.mas_bottom);
        make.right.mas_equalTo(whiteView);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(15));
    }];
    
    UILabel *idcard=[self getBlackLabel:@"身份证"];
    [whiteView addSubview:idcard];
    [idcard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(idcardLine.mas_bottom);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(15));
        make.height.mas_equalTo(GetHeight(49.5));
    }];
    
    idcardField=[self getTextField:@"请输入持卡人身份证号"];
    [whiteView addSubview:idcardField];
    [idcardField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(idcard.mas_top);
        make.height.mas_equalTo(idcard);
        make.left.mas_equalTo(whiteView.mas_left).offset(GetWidth(80));
        make.right.mas_equalTo(whiteView.mas_right).offset(-GetWidth(15));
    }];
    
    UIView *bottonLine=[self getLineView];
    [whiteView addSubview:bottonLine];
    [bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(whiteView.mas_bottom);
        make.right.mas_equalTo(whiteView);
        make.left.mas_equalTo(whiteView.mas_left);
    }];
    
    bangding=[UIButton buttonWithTitle:@"绑定" titleColor:[UIColor whiteColor] font:font17 target:self action:@selector(bangding:)];
    [bangding setBackgroundImage:[UIImage imageNamed:@"btnormal"] forState:0];
    [bangding setBackgroundImage:[UIImage imageNamed:@"btforbidden"] forState:UIControlStateDisabled];
    [bangding setBackgroundImage:[UIImage imageNamed:@"btclick"] forState:UIControlStateHighlighted];
    bangding.enabled=NO;
    [contentView addSubview:bangding];
    [bangding mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(whiteView.mas_bottom).offset(GetHeight(85));
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(50));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(50));
        make.height.mas_equalTo(GetHeight(40));
    }];
    
    
    UIButton *callPhone=[UIButton buttonWithTitle:@"客服电话 400 1114 567" titleColor:color0086ff font:font13 target:self action:@selector(callPhone:)];
    [callPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:@"客服电话 400 1114 567"];
    [attr addAttribute:NSForegroundColorAttributeName value:color0086ff range:NSMakeRange(0, @"客服电话 400 1114 567".length)];
    [attr addAttribute:NSForegroundColorAttributeName value:color595959 range:NSMakeRange(0, 4)];
    [callPhone setAttributedTitle:attr forState:0];
    [contentView addSubview:callPhone];
    [callPhone mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(bangding.mas_bottom).offset(GetHeight(190));
        make.height.mas_equalTo(44);
    }];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(callPhone.mas_bottom).offset(GetHeight(30));
    }];
    
    [self setIQKeyBorderManager];
    
}

//获取横线
- (UIView *)getLineView{
    UIView *lineUP=[[UIView alloc]init];
    lineUP.backgroundColor=colorc3c3c3;
    [lineUP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];
    return lineUP;
}

//获取白色背景
- (UIView *)getWhiteView{
    UIView *whiteBg=[[UIView alloc]init];
    whiteBg.backgroundColor=[UIColor whiteColor];
    return whiteBg;
}

//获取黑色label
- (UILabel *)getBlackLabel:(NSString *)labelName{
    UILabel *label=[[UILabel alloc]init];
    label.text=labelName;
    label.textColor=color595959;
    label.font=font16;
    return label;
}

//获取输入框
- (UITextField *)getTextField:(NSString *)placeHolder{
    UITextField *textFiled=[[UITextField alloc]init];
    textFiled.font=font16;
    textFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    textFiled.delegate=self;
    textFiled.placeholder=placeHolder;
    textFiled.tintColor=[UIColor darkGrayColor];
    textFiled.textColor=color787878;
    textFiled.textAlignment=NSTextAlignmentLeft;
    [textFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    return textFiled;
}

//新增银行卡
- (void)bangding:(UIButton *)sender{
    if ([numberBOOL checkUserIdCard:[self clearSpace:idcardField.text]]==NO) {
        [MBProgressHUD showError:@"请输入有效的身份证号"];
        return;
    }
    if ([numberBOOL checkCardNo:[[self clearSpace:bankField.text] stringByReplacingOccurrencesOfString:@" " withString:@""]]==NO) {
        [MBProgressHUD showError:@"请输入有效的银行卡号"];
        return;
    }
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,bindBankCard];
    NSDictionary *dic=@{@"tradeType":@(1),@"bankId":[self clearAllSpace:bankField.text],@"bankName":bankName,@"accountAddress":[self clearSpace:kaihuhangField.text],@"cardid":[self clearSpace:idcardField.text]};
    [XWNetworking postJsonWithUrl:url params:dic  success:^(id response) {
        [self saveData:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"新增银行卡失败"];
    } showHud:NO];
}

#pragma mark 保存更新用户数据
- (void)saveData:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else{
            user.bankName=[response[@"data"] stringForKey:@"bankName"];
            user.bankId=[response[@"data"] stringForKey:@"bankId"];
            user.accountAddress=[response[@"data"] stringForKey:@"accountAddress"];;
            user.cardid=[response[@"data"] stringForKey:@"cardid"];;
            NSData *userData=[NSKeyedArchiver archivedDataWithRootObject:user];
            [UserDefaults setObject:userData forKey:USER];
            [NotiCenter postNotificationName:@"changeBankID" object:nil];
            [MBProgressHUD showSuccess:@"绑定成功"];
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


#pragma mark - 输入框改变事件
/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if (bankField == textField || kaihuhangField == textField|| nameField == textField||idcardField == textField) {
        bangding.enabled = (bankField.text.length && kaihuhangField.text.length&& nameField.text.length&& idcardField.text.length);
    }
    if (textField==bankField){
        if ([self clearAllSpace:bankField.text].length<16||[numberBOOL checkCardNo:[self clearAllSpace:bankField.text]]==NO) {
            bankName=@"";
            bankNameLabel.text=@"";
            return;
        }
        bankName=[self returnBankName:[self clearAllSpace:bankField.text]];
        bankNameLabel.text=[NSString stringWithFormat:@"( %@ )",bankName];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==bankField){
        if ([self clearSpace:bankField.text].length<16||[numberBOOL checkCardNo:[self clearAllSpace:bankField.text]]==NO) {
            return;
        }
        bankName=[self returnBankName:[self clearAllSpace:bankField.text]];
        bankNameLabel.text=[NSString stringWithFormat:@"( %@ )",bankName];
    }
}

#ifdef __IPHONE_10_0
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (textField==bankField){
        if ([self clearSpace:bankField.text].length<16||[numberBOOL checkCardNo:[self clearAllSpace:bankField.text]]==NO) {
            return;
        }
        bankName=[self returnBankName:[self clearAllSpace:bankField.text]];
        bankNameLabel.text=[NSString stringWithFormat:@"( %@ )",bankName];
    }
}
#endif

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==bankField) {
        if (range.location==24) {
            return NO;
        }
        if ([string isEqualToString:@""]) {
            if ((textField.text.length - 2) % 5 == 0) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        } else {
            if (textField.text.length % 5 == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        return YES;
    }else if(idcardField == textField) {
        if (range.location==18) {
            return NO;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789Xx"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
