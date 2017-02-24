//
//  QMYBJiluTableViewCell.m
//  QMYB
//
//  Created by 大家保 on 2017/2/24.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBJiluTableViewCell.h"

@implementation QMYBJiluTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.statusLabel=[[UILabel alloc]init];
        self.statusLabel.textColor=color595959;
        self.statusLabel.font=font17;
        self.statusLabel.text=@"收益";
        [self.contentView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(GetWidth(15));
            make.top.mas_equalTo(self.contentView.mas_top).offset(GetHeight(10));
        }];
        
        self.dataLabel=[[UILabel alloc]init];
        self.dataLabel.textColor=color595959;
        self.dataLabel.font=font15;
        self.dataLabel.text=@"185****8888";
        [self.contentView addSubview:self.dataLabel];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.statusLabel);
            make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(GetHeight(2));
        }];
        
        self.priceLabel=[[UILabel alloc]init];
        self.priceLabel.textColor=colorf28300;
        self.priceLabel.font=font18;
        self.priceLabel.text=@"300.00";
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-GetWidth(15));
        }];
        
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
