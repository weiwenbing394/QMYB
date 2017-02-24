//
//  QMYBDianyuanListCell.m
//  QMYB
//
//  Created by 大家保 on 2017/2/24.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBDianyuanListCell.h"

@implementation QMYBDianyuanListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel=[[UILabel alloc]init];
        self.nameLabel.textColor=color595959;
        self.nameLabel.font=font17;
        self.nameLabel.text=@"钱多多";
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(GetWidth(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        
        self.dataLabel=[[UILabel alloc]init];
        self.dataLabel.textColor=color595959;
        self.dataLabel.font=font17;
        self.dataLabel.text=@"2017-02-09";
        self.dataLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.dataLabel];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-GetWidth(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.zhanghaoLabel=[[UILabel alloc]init];
        self.zhanghaoLabel.textColor=color595959;
        self.zhanghaoLabel.font=font17;
        self.zhanghaoLabel.text=@"185****8888";
        [self.contentView addSubview:self.zhanghaoLabel];
        [self.zhanghaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(GetWidth(100));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.dataLabel.mas_left).offset(-GetWidth(15));
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
