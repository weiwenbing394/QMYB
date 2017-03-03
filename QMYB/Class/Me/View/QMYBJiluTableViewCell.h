//
//  QMYBJiluTableViewCell.h
//  QMYB
//
//  Created by 大家保 on 2017/2/24.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZhanghuList;

@interface QMYBJiluTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *statusLabel;

@property (nonatomic,strong)UILabel *dataLabel;

@property (nonatomic,strong)UILabel *priceLabel;

@property (nonatomic,strong)ZhanghuList *model;

@end
