//
//  QMYBJiaoyiTableViewCell.m
//  QMYB
//
//  Created by 大家保 on 2017/2/23.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBJiaoyiTableViewCell.h"

@implementation QMYBJiaoyiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.picImageView=[[UIImageView alloc]init];
        self.picImageView.layer.cornerRadius=2;
        self.picImageView.clipsToBounds=YES;
        self.picImageView.image=[UIImage imageNamed:@"渐变"];
        [self.contentView addSubview:self.picImageView];
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.contentView).offset(GetWidth(15));
            make.height.width.mas_equalTo(GetHeight(60));
        }];
        
        self.statusLabel=[[UILabel alloc]init];
        self.statusLabel.textColor=color787878;
        self.statusLabel.font=font14;
        self.statusLabel.text=@"已成单";
        [self.contentView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-GetWidth(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.priceLabel=[[UILabel alloc]init];
        self.priceLabel.textColor=colorf28300;
        self.priceLabel.font=font14;
        self.priceLabel.text=@"+50元";
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-GetWidth(15));
            make.bottom.mas_equalTo(self.picImageView.mas_bottom);
        }];

        
        self.titleLabel=[[UILabel alloc]init];
        self.titleLabel.textColor=color595959;
        self.titleLabel.font=font15;
        self.titleLabel.numberOfLines=2;
        self.titleLabel.text=@"产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称";
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.picImageView.mas_right).offset(GetWidth(15));
            make.top.mas_equalTo(self.contentView.mas_top).offset(GetWidth(15));
            make.right.mas_equalTo(self.statusLabel.mas_left).offset(-GetWidth(15));
        }];
        
        self.dataLabel=[[UILabel alloc]init];
        self.dataLabel.textColor=color787878;
        self.dataLabel.font=font13;
        self.dataLabel.numberOfLines=2;
        self.dataLabel.text=@"2017-02-08 10:50";
        [self.contentView addSubview:self.dataLabel];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.priceLabel.mas_left).offset(-GetWidth(15));
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.bottom.mas_equalTo(self.picImageView.mas_bottom);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
