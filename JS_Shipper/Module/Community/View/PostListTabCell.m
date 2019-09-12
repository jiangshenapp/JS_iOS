//
//  PostListTabCell.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/12.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "PostListTabCell.h"

@implementation PostListTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModel:(JSPostListModel *)dataModel {
    self.timeLab.text = [NSString stringWithFormat:@"%@发布",[Utils getTimeStrToCurrentDateWith:dataModel.createTime]];
    self.zanNumberLab.text = dataModel.likeCount;
    self.commentNumLab.text = dataModel.commentCount;
    self.contentLab.text = dataModel.content;
    self.nameLab.text = dataModel.nickName;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:dataModel.avatar] placeholderImage:DefaultImage];
    self.likeBtn.selected = [dataModel.likeFlag boolValue];
    self.tag1Lab.hidden = YES;
    self.tag2Lab.hidden = YES;
    if ([dataModel.star boolValue]) {
        self.tag1Lab.hidden = NO;
        self.tag1Lab.text = @"精品";
    }
    if ([dataModel.type boolValue]) {
        self.tag2Lab.hidden = NO;
        self.tag2Lab.text = @"官方";
    }
}

@end
