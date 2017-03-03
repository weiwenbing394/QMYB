//
//  QMYBJiluTableViewCell.m
//  QMYB
//
//  Created by 大家保 on 2017/2/24.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBJiluTableViewCell.h"
#import "ZhanghuList.h"

@implementation QMYBJiluTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.statusLabel=[[UILabel alloc]init];
        self.statusLabel.textColor=color595959;
        self.statusLabel.font=font17;
        [self.contentView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(GetWidth(15));
            make.top.mas_equalTo(self.contentView.mas_top).offset(GetHeight(10));
        }];
        
        self.dataLabel=[[UILabel alloc]init];
        self.dataLabel.textColor=color595959;
        self.dataLabel.font=font15;
        [self.contentView addSubview:self.dataLabel];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.statusLabel);
            make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(GetHeight(2));
        }];
        
        self.priceLabel=[[UILabel alloc]init];
        self.priceLabel.textColor=colorf28300;
        self.priceLabel.font=font18;
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-GetWidth(15));
        }];
        
        
    }
    return self;
}

- (void)setModel:(ZhanghuList *)model{
    float chaju=fabsf(model.beforeAccountAmt-model.afterAccountAmt);
    if (model.tradeType==20001) {
        self.statusLabel.text=@"收益";
        self.priceLabel.textColor=colorf28300;
        self.priceLabel.text=[NSString stringWithFormat:@"+%.2f",chaju];
    }else if (model.tradeType==20002){
        self.statusLabel.text=@"提现";
        self.priceLabel.textColor=color00bc54;
        self.priceLabel.text=[NSString stringWithFormat:@"-%.2f",chaju];
    }else if (model.tradeType==20003){
        self.statusLabel.text=@"退单";
        self.priceLabel.textColor=color00bc54;
        self.priceLabel.text=[NSString stringWithFormat:@"-%.2f",chaju];
    }
    
    self.dataLabel.text=model.accountId.length>8?[self place:model.accountId]:model.accountId;
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
