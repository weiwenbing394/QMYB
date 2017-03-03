//
//  UserShouyi.h
//  QMYB
//
//  Created by 大家保 on 2017/3/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserShouyi : NSObject
//当月总收益
@property (nonatomic,assign)CGFloat sameMonthTotalCommission;
//今日总收益
@property (nonatomic,assign)CGFloat todayTotalCommission;
//今日退单金额
@property (nonatomic,assign)CGFloat surrenderTotalAmt;
//记录条数model
@property (nonatomic,strong)NSMutableArray *emps;

@end
