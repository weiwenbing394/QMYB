//
//  Shouyi.h
//  QMYB
//
//  Created by 大家保 on 2017/3/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shouyi : NSObject
//姓名
@property (nonatomic,copy)NSString *businessName;
//账号
@property (nonatomic,copy)NSString *phone;
//日收益
@property (nonatomic,assign)CGFloat dayCommission;
//当月收益
@property (nonatomic,assign)CGFloat monthCommission;

@end
