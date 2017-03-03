//
//  QMYBJiaoyiTableViewCell.h
//  QMYB
//
//  Created by 大家保 on 2017/2/23.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Jiaoyi;

@interface QMYBJiaoyiTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *picImageView;

@property (nonatomic,strong)UILabel     *titleLabel;

@property (nonatomic,strong)UILabel     *dataLabel;

@property (nonatomic,strong)UILabel     *statusLabel;

@property (nonatomic,strong)UILabel     *priceLabel;

@property (nonatomic,strong)Jiaoyi      *model;

@end
