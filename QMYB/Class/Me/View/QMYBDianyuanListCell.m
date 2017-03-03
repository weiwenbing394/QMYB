//
//  QMYBDianyuanListCell.m
//  QMYB
//
//  Created by 大家保 on 2017/2/24.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBDianyuanListCell.h"
#import "Dianyuan.h"

@implementation QMYBDianyuanListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.nameLabel=[[UILabel alloc]init];
        self.nameLabel.textColor=color595959;
        self.nameLabel.font=font15;
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(GetWidth(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        
        self.dataLabel=[[UILabel alloc]init];
        self.dataLabel.textColor=color595959;
        self.dataLabel.font=font15;
        self.dataLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.dataLabel];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-GetWidth(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.zhanghaoLabel=[[UILabel alloc]init];
        self.zhanghaoLabel.textColor=color595959;
        self.zhanghaoLabel.font=font15;
        [self.contentView addSubview:self.zhanghaoLabel];
        [self.zhanghaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(GetWidth(100));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.dataLabel.mas_left).offset(-GetWidth(15));
        }];
    }
    return self;
}

- (void)setModel:(Dianyuan *)model{
    self.nameLabel.text=model.businessName?model.businessName:@"";
    self.dataLabel.text=[self timeToString:model.createTime];
    self.zhanghaoLabel.text=model.phone.length>8?[self place:model.phone]:model.phone;
}

- (NSString *)timeToString:(long long) miaoshu{
    NSDate *date =[[NSDate alloc]initWithTimeIntervalSince1970:miaoshu/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:zone];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)place:(NSString *)str{
    NSMutableString *cardIdStr=[[NSMutableString alloc]initWithString:str];
    for (int i=3; i<cardIdStr.length-4; i++) {
        [cardIdStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return cardIdStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
