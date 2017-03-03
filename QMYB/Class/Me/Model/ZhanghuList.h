//
//  ZhanghuList.h
//  QMYB
//
//  Created by 大家保 on 2017/3/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhanghuList : NSObject
//状态 （20001 收益，20002 提现，20003 退单，）
@property (nonatomic,assign) NSInteger tradeType;
//账户
@property (nonatomic,copy) NSString *accountId;
//之前金额
@property (nonatomic,assign)float  beforeAccountAmt;
//之后金额
@property (nonatomic,assign)float  afterAccountAmt;


@end
