//
//  QMYBNewDianyuanViewController.h
//  QMYB
//
//  Created by 大家保 on 2017/2/24.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBBaseViewController.h"

@interface QMYBNewDianyuanViewController : QMYBBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrants;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userTextFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userTextfieldRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTextfieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTextFieldRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomHeight;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneField;
@property (weak, nonatomic) IBOutlet UIButton *creatButtom;
@end
