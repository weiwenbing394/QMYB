//
//  User.h
//  QMYB
//
//  Created by 大家保 on 2017/2/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

//银行名称
@property (nonatomic,copy)NSString *bankName;
//银行卡号
@property (nonatomic,copy)NSString *bankId;
//开户支行
@property (nonatomic,copy)NSString *accountAddress;
//身份证号
@property (nonatomic,copy)NSString *cardid;


//用户名
@property (nonatomic,copy)NSString *businessName;
//电话
@property (nonatomic,copy)NSString *phone;
//用户id
@property (nonatomic,assign)NSInteger userId;
//用户类型 （4 店长，5 店员）
@property (nonatomic,assign)NSInteger level;

//日收益
@property (nonatomic,assign)CGFloat dayCommission;
//总推广费
@property (nonatomic,assign)CGFloat accountAmt;
//可提现
@property (nonatomic,assign)CGFloat withdrawAmt;
//账户号
@property (nonatomic,copy)NSString *accountCode;

@end
