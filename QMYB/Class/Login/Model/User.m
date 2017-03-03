//
//  User.m
//  QMYB
//
//  Created by 大家保 on 2017/2/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "User.h"

@implementation User

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder  encodeObject:self.bankName forKey:@"bankName"];
    [aCoder  encodeObject:self.bankId forKey:@"bankId"];
    [aCoder  encodeObject:self.accountAddress forKey:@"accountAddress"];
    [aCoder  encodeObject:self.cardid forKey:@"cardid"];
    [aCoder  encodeObject:self.businessName forKey:@"businessName"];
    [aCoder  encodeObject:self.phone forKey:@"phone"];
    [aCoder  encodeObject:self.accountCode forKey:@"accountCode"];
    
    [aCoder  encodeInteger:self.userId forKey:@"userId"];
    [aCoder  encodeInteger:self.level forKey:@"level"];
    
    
    [aCoder  encodeFloat:self.dayCommission forKey:@"dayCommission"];
    [aCoder  encodeFloat:self.accountAmt forKey:@"accountAmt"];
    [aCoder  encodeFloat:self.withdrawAmt forKey:@"withdrawAmt"];

}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.bankName=[aDecoder decodeObjectForKey:@"bankName"];
        self.bankId=[aDecoder decodeObjectForKey:@"bankId"];
        self.accountAddress=[aDecoder decodeObjectForKey:@"accountAddress"];
        self.cardid=[aDecoder decodeObjectForKey:@"cardid"];
        self.businessName=[aDecoder decodeObjectForKey:@"businessName"];
        self.phone=[aDecoder decodeObjectForKey:@"phone"];
        self.accountCode=[aDecoder decodeObjectForKey:@"accountCode"];
        
        self.userId=[aDecoder decodeIntegerForKey:@"userId"];
        self.level=[aDecoder decodeIntegerForKey:@"level"];
        
        self.dayCommission=[aDecoder decodeFloatForKey:@"dayCommission"];
        self.accountAmt=[aDecoder decodeFloatForKey:@"accountAmt"];
        self.withdrawAmt=[aDecoder decodeFloatForKey:@"withdrawAmt"];
    }
    return self;
}

@end
