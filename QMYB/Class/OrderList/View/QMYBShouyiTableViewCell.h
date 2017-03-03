//
//  QMYBShouyiTableViewCell.h
//  QMYB
//
//  Created by 大家保 on 2017/2/23.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Shouyi;

@interface QMYBShouyiTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *zhanghaoLabel;

@property (nonatomic,strong)UILabel *rishouyiLabel;

@property (nonatomic,strong)UILabel *monthLabel;

@property (nonatomic,strong)Shouyi  *model;

@end
