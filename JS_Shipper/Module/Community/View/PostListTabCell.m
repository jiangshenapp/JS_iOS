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
    self.tag1View.hidden = YES;
    self.tag2View.hidden = YES;
    NSArray *arr = @[dataModel.star,dataModel.type];
    NSArray *labelArr = @[self.tag1Lab,self.tag2Lab];
    NSArray *titleStrArr = @[@"精品",@"官方"];
    NSInteger count = 0;
    for (NSInteger index = 0; index < 2; index++) {
        if ([arr[index] integerValue]==1) {
            UILabel *label = labelArr[count];
            label.superview.hidden = NO;
            label.text = titleStrArr[index];
            count++;
        }
    }

//    if ([dataModel.star boolValue]) {
//        self.tag1View.hidden = NO;
//        self.tag1Lab.text = @"精品";
//    }
//    if ([dataModel.type boolValue]) {
//        self.tag2View.hidden = NO;
//        self.tag2Lab.text = @"官方";
//    }
}

@end
