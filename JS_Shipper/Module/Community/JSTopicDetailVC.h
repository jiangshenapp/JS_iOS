//
//  JSTopicDetailVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "JSPostListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSTopicDetailVC : BaseVC
/** <#object#> */
@property (nonatomic,retain) JSPostListModel *dataModel;
@property (weak, nonatomic) IBOutlet UIImageView *circleImgView;
@property (weak, nonatomic) IBOutlet UILabel *circleNameLab;

@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@property (weak, nonatomic) IBOutlet UILabel *commentLab;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLab;

- (IBAction)followBtnClickAction:(UIButton *)sender;

@end

@interface TopicDetailTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;

@property (weak, nonatomic) IBOutlet UIImageView *commentHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *commentNameLab;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgH;

@end

@interface CommentListData : BaseItem
/** <#object#> */
@property (nonatomic,copy) NSString *comment;
/** 评论人*/
@property (nonatomic,copy) NSString *createBy;
/** 帖子ID */
@property (nonatomic,copy) NSString *postId;
/** <#object#> */
@property (nonatomic,copy) NSString *ID;
/** <#object#> */
@property (nonatomic,copy) NSString *createTime;
/** <#object#> */
@property (nonatomic,copy) NSString *delFlag;
/** <#object#> */
@property (nonatomic,copy) NSString *nickName;
@end

NS_ASSUME_NONNULL_END
