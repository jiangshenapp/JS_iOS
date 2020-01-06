//
//  JSMyTransportTabCell.h
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/6.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyTransportTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UIButton *bookOrderBtn;
/** 数据源 */
@property (nonatomic,retain) RecordsModel *dataModel;
@end


NS_ASSUME_NONNULL_END
