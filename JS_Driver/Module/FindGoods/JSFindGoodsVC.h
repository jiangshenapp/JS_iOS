//
//  JSFindGoodsVC.h
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"
#import "OrderInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSFindGoodsVC : BaseVC<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *filterView;

@end

@interface FindGoodsTabCell : UITableViewCell
/** 订单号 */
@property (weak, nonatomic) IBOutlet UILabel *orderNOLab;
/** 发布时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
/** 起止点 */
@property (weak, nonatomic) IBOutlet UIButton *startDotNameLab;
/** 终点 */
@property (weak, nonatomic) IBOutlet UIButton *endDotNameLab;
/** 装货时间 */
@property (weak, nonatomic) IBOutlet UILabel *getGoodsTimeLab;
/** 货车信息 */
@property (weak, nonatomic) IBOutlet UILabel *orderCarInfoLab;
/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *iphoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@end




NS_ASSUME_NONNULL_END
