//
//  JSMyCarVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"
#import "CarModel.h"

typedef void (^SelectCarBlock) (CarModel * _Nullable carModel);

NS_ASSUME_NONNULL_BEGIN

@interface JSMyCarVC : BaseVC

/** 选择车辆回调 */
@property (nonatomic,copy) SelectCarBlock selectCarBlock;
/** 选择车辆入口 YES */
@property (nonatomic,assign) BOOL isSelect;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

- (IBAction)cancleSearchTF:(UIButton *)sender;

@end

@interface MyCarTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *carNumLab;
@property (weak, nonatomic) IBOutlet UILabel *checkStateLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIImageView *carImgView;

@end

NS_ASSUME_NONNULL_END
