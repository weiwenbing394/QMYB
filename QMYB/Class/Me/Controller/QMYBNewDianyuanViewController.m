//
//  QMYBNewDianyuanViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/24.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBNewDianyuanViewController.h"
#import "User.h"

@interface QMYBNewDianyuanViewController (){
    User *user;
}

@end

@implementation QMYBNewDianyuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self addTitle:@"创建新店员"];
    user=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults objectForKey:USER] ];
    [self.userNameField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.userPhoneField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}
//创建一个用户
- (IBAction)create:(id)sender {
    if (0==[self clearSpace:self.userNameField.text].length) {
        [MBProgressHUD ToastInformation:@"店员姓名不能为空"];
        return;
    }
    if (![numberBOOL checkTelNumber:self.userPhoneField.text]) {
        [MBProgressHUD ToastInformation:@"请输入正确的手机号"];
        return;
    }
    if ([user.phone isEqualToString:self.userPhoneField.text]) {
        [MBProgressHUD ToastInformation:@"不能将自己的手机号用做店员账号"];
        return;
    }
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,addEmployee];
    NSDictionary *dic=@{@"phone":[self clearSpace:self.userPhoneField.text],@"businessName":[self clearSpace:self.userNameField.text]};
    [XWNetworking postJsonWithUrl:url params:dic  success:^(id response) {
        NSLog(@"%@",response);
        [self saveData:response];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"创建店员失败，请重试"];
    } showHud:YES];
}

- (void)saveData:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else{
            [MBProgressHUD showSuccess:@"创建成功！已发送短信通知"];
            [NotiCenter postNotificationName:@"addEmployee" object:nil];
        }
    }

}

#pragma mark - 输入框改变事件
/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if (self.userPhoneField == textField || self.userNameField == textField) {
        self.creatButtom.enabled = (self.userPhoneField.text.length && self.userNameField.text.length);
    }
    //  限制输入框的输入长度为11
    if (self.userPhoneField == textField&&textField.text.length >= 11 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:11];
    }
    //  限制输入框的输入长度为30
    if (self.userNameField == textField  && textField.text.length >=30 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:30];
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.topConstrants.constant=79;
    self.bgViewHeight.constant=GetHeight(100);
    self.userLeft.constant=GetWidth(15);
    self.userHeight.constant=GetHeight(50);
    self.userRight.constant=GetWidth(42);
    self.userTextFieldHeight.constant=GetWidth(50);
    self.userTextfieldRight.constant=GetWidth(15);
    self.phoneLeft.constant=GetWidth(15);
    self.phoneHeight.constant=GetHeight(50);
    self.phoneRight.constant=GetWidth(26);
    self.phoneTextfieldHeight.constant=GetWidth(50);
    self.phoneTextFieldRight.constant=GetWidth(15);
    self.buttomLeft.constant=GetWidth(60);
    self.buttomTop.constant=GetHeight(100);
    self.buttomRight.constant=GetWidth(60);
    self.buttomHeight.constant=GetHeight(40);
    [self setIQKeyBorderManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
