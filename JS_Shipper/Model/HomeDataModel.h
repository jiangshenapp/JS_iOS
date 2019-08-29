//
//  HomeDataModel.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"
#import "RecordsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeDataModel : BaseItem

/** 数据源 */
@property (nonatomic,retain) NSArray<RecordsModel *> *records;
@property (nonatomic,copy) NSString *size;
@property (nonatomic,copy) NSString *current;
@property (nonatomic,copy) NSString *searchCount;
@property (nonatomic,copy) NSString *pages;
@property (nonatomic,copy) NSString *total;

@end

NS_ASSUME_NONNULL_END
