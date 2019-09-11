//
//  JSPostListModel.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/9.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSPostListModel : BaseItem
/** <#object#> */
@property (nonatomic,copy) NSString *createTime;
/** object */
@property (nonatomic,copy) NSString *ID;
/** 话题名字 */
@property (nonatomic,copy) NSString *subject;

/** object */
@property (nonatomic,copy) NSString *delFlag;

/** object */
@property (nonatomic,copy) NSString *circleId;

/** object */
@property (nonatomic,copy) NSString *content;
/** 是否已经点赞 */
@property (nonatomic,copy) NSString *likeFlag;
/** object */
@property (nonatomic,copy) NSString *author;

/** 精华，1是，0否 */
@property (nonatomic,copy) NSString *star;

/** 类型，1官方2非官方 */
@property (nonatomic,copy) NSString *type;

/** object */
@property (nonatomic,copy) NSString *title;
/** object */
@property (nonatomic,copy) NSString *auditRemark;
/** <#object#> */
@property (nonatomic,copy) NSString *nickName;
///** <#object#> */
//@property (nonatomic,copy) NSString *avatar;
//
///** object */
//@property (nonatomic,copy) NSString *image;


/** object */
@property (nonatomic,copy) NSString *auditBy;


/** object */
@property (nonatomic,copy) NSString *commentCount;
/** object */
@property (nonatomic,copy) NSString *likeCount;

/** object */
@property (nonatomic,copy) NSString *auditStatus;
/** object */
@property (nonatomic,copy) NSString *auditTime;






@end

NS_ASSUME_NONNULL_END
