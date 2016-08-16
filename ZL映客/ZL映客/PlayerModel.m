//
//  PlayerModel.m
//  ZL映客
//
//  Created by fengei on 16/8/4.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "PlayerModel.h"

@implementation PlayerModel

- (instancetype)initWithDic:(NSDictionary *) dic
{
    self = [super init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.ID = value;
    }
}
@end
