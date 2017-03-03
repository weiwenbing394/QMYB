//
//  QMYBJiaoyiTableViewCell.m
//  QMYB
//
//  Created by 大家保 on 2017/2/23.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBJiaoyiTableViewCell.h"
#import "Jiaoyi.h"

@implementation QMYBJiaoyiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.picImageView=[[UIImageView alloc]init];
        self.picImageView.layer.cornerRadius=2;
        self.picImageView.clipsToBounds=YES;
        [self.contentView addSubview:self.picImageView];
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.contentView).offset(GetWidth(15));
            make.height.width.mas_equalTo(GetHeight(60));
        }];
        
        self.statusLabel=[[UILabel alloc]init];
        self.statusLabel.textColor=color787878;
        self.statusLabel.font=font14;
        self.statusLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-GetWidth(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.priceLabel=[[UILabel alloc]init];
        self.priceLabel.font=font14;
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-GetWidth(15));
            make.bottom.mas_equalTo(self.picImageView.mas_bottom);
        }];

        
        self.titleLabel=[[UILabel alloc]init];
        self.titleLabel.textColor=color595959;
        self.titleLabel.font=font15;
        self.titleLabel.numberOfLines=2;
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
        [self.contentView addSubview:self.dataLabel];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.priceLabel.mas_left).offset(-GetWidth(15));
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.bottom.mas_equalTo(self.picImageView.mas_bottom);
        }];
    }
    return self;
}

- (void)setModel:(Jiaoyi *)model{
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:0==model.productImage.length?@"":model.productImage] placeholderImage:[UIImage imageNamed:@"空白页"]];
        NSString *price;
        if (model.tradeType==1) {
            self.statusLabel.text=@"已成单";
            price=[NSString stringWithFormat:@"+%.2f元",model.premium];
            NSMutableAttributedString *mutableString=[[NSMutableAttributedString alloc]initWithString:price];
            [mutableString addAttribute:NSForegroundColorAttributeName value:color787878 range:NSMakeRange(price.length-1, 1)];
            [mutableString addAttribute:NSForegroundColorAttributeName value:colorf28300 range:NSMakeRange(0, price.length-1)];
            [mutableString addAttribute:NSFontAttributeName value:font12 range:NSMakeRange(price.length-1, 1)];
            self.priceLabel.attributedText=mutableString;
        }else{
            self.statusLabel.text=@"已退单";
            price=[NSString stringWithFormat:@"-%.2f元",model.premium];
            NSMutableAttributedString *mutableString=[[NSMutableAttributedString alloc]initWithString:price];
            [mutableString addAttribute:NSForegroundColorAttributeName value:color787878 range:NSMakeRange(price.length-1, 1)];
            [mutableString addAttribute:NSForegroundColorAttributeName value:color00bc54 range:NSMakeRange(0, price.length-1)];
            [mutableString addAttribute:NSFontAttributeName value:font12 range:NSMakeRange(price.length-1, 1)];
            self.priceLabel.attributedText=mutableString;
        }
        self.titleLabel.text=model.productName?model.productName:@"";
        self.dataLabel.text=[self timeToString:model.tradeTime];
}

- (NSString *)timeToString:(long long) miaoshu{
    NSDate *date =[[NSDate alloc]initWithTimeIntervalSince1970:miaoshu/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:zone];
    return [dateFormatter stringFromDate:date];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
