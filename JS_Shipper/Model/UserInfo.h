//
//  UserInfo.h
//  Chaozhi
//  Notes：用户model
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"

@interface UserInfo : BaseItem

@property (nonatomic,copy) NSString *token; //用户token
@property (nonatomic,copy) NSString *mobile; //手机号码
@property (nonatomic,copy) NSString *nickName; //昵称
@property (nonatomic,copy) NSString *avatar; //头像
@property (nonatomic,copy) NSString *lastPosition; //
@property (nonatomic,copy) NSString *lastPositionTime; //
@property (nonatomic,copy) NSString *driverVerified; //是否认证司机身份，0未认证，1审核中，2已认证，3认证失败
@property (nonatomic,copy) NSString *parkVerified; //是否认证园区身份，0未认证，1审核中，2已认证，3认证失败
@property (nonatomic,copy) NSString *personConsignorVerified; //是否认证个人货主，0未认证，1审核中，2已认证，3认证失败
@property (nonatomic,copy) NSString *companyConsignorVerified; //是否认证企业货主身份，0未认证，1审核中，2已认证，3认证失败

+ (UserInfo *)share;

- (void)setUserInfo:(NSMutableDictionary *)userDic;

- (void)removeUserInfo;

@end
