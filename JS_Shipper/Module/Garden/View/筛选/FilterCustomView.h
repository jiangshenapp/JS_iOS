//
//  FilterCustomView.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/24.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCustomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterCustomView : BaseCustomView
/** 单选多选数组  0多选选  1单选 */
@property (nonatomic,retain) NSArray *singleArr;
/** 原生数据源 key-value(数组) */
@property (nonatomic,retain) NSDictionary *dataDic;
/** 获取到结果 */
@property (nonatomic,copy) void (^getPostDic)(NSDictionary *dic,NSArray *titlesArr);
@end

@interface MyCustomView : UIView
{
    MyCustomButton *lastSelectBtn;
    NSMutableArray *allButtonArr;
//    NSMutableArray *selectDataDic;
}
/** 选中的标题 */
@property (nonatomic,copy) NSString *titles;
/** 选中的值 */
@property (nonatomic,copy) NSString *values;
/** 是否是单选 */
@property (nonatomic,assign) BOOL isSingle;
/** 是否清空条件 */
@property (nonatomic,assign) BOOL isClear;
/** 数据源 */
@property (nonatomic,retain) NSArray *dataSource;

@property (nonatomic,copy)  void (^getSlectInfoStr)(NSString *titles,NSString *values);

- (instancetype)initWithdataSource:(NSArray *)dataSource andTilte:(NSString *)titleStr;
@end


NS_ASSUME_NONNULL_END
