//
//  PlayerModel.h
//  ZL映客
//
//  Created by fengei on 16/8/4.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerModel : NSObject

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *portrait;
@property (nonatomic,assign) int online_users;
@property (nonatomic,strong) NSString *url;

- (instancetype)initWithDic:(NSDictionary *) dic;
@end
