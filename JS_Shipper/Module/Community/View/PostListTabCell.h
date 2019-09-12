//
//  PostListTabCell.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/12.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSPostListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostListTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *tag1Lab;
@property (weak, nonatomic) IBOutlet UILabel *tag2Lab;
@property (weak, nonatomic) IBOutlet UILabel *zanNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
/** 数据源 */
@property (nonatomic,retain) JSPostListModel *dataModel;
@end

NS_ASSUME_NONNULL_END
