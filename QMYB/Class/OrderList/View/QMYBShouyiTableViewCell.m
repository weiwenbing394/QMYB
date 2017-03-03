//
//  QMYBShouyiTableViewCell.m
//  QMYB
//
//  Created by 大家保 on 2017/2/23.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBShouyiTableViewCell.h"
#import "Shouyi.h"

@implementation QMYBShouyiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.nameLabel=[[UILabel alloc]init];
        self.nameLabel.textColor=color595959;
        self.nameLabel.font=font15;
        self.nameLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(SCREEN_WIDTH/4.0);
        }];
        
        self.zhanghaoLabel=[[UILabel alloc]init];
        self.zhanghaoLabel.textColor=color595959;
        self.zhanghaoLabel.font=font15;
        self.zhanghaoLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.zhanghaoLabel];
        [self.zhanghaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(SCREEN_WIDTH/4.0);
        }];

        self.rishouyiLabel=[[UILabel alloc]init];
        self.rishouyiLabel.textColor=colorf28300;
        self.rishouyiLabel.font=font15;
        self.rishouyiLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.rishouyiLabel];
        [self.rishouyiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.zhanghaoLabel.mas_right);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(SCREEN_WIDTH/4.0);
        }];

        self.monthLabel=[[UILabel alloc]init];
        self.monthLabel.textColor=color595959;
        self.monthLabel.font=font15;
        self.monthLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.monthLabel];
        [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rishouyiLabel.mas_right);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(SCREEN_WIDTH/4.0);
        }];
    }
    return self;
}

- (void)setModel:(Shouyi *)model{
    self.nameLabel.text=model.businessName?model.businessName:@"";
    self.zhanghaoLabel.text=model.phone?model.phone:@"";
    self.rishouyiLabel.text=[NSString stringWithFormat:@"%.2f",model.dayCommission];
    self.monthLabel.text=[NSString stringWithFormat:@"%.2f",model.monthCommission];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
