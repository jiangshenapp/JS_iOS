//
//  JSTopicDetailVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSTopicDetailVC.h"
#import "JSSendCommentVC.h"

@interface JSTopicDetailVC ()<UITableViewDelegate,UITableViewDataSource>
/** 评论数据源 */
@property (nonatomic,retain) NSMutableArray <CommentListData *>*commentDataSource;
@end

@implementation JSTopicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _praiseNumLab.text = _dataModel.likeCount;
    _commentLab.text = _dataModel.commentCount;
    _commentDataSource = [NSMutableArray array];
    [self getCommentData];
    // Do any additional setup after loading the view.
}

- (void)getCommentData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?postId=%@",URL_PostCommentList,_dataModel.ID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success&&[responseData isKindOfClass:[NSArray class]]) {
            [weakSelf.commentDataSource removeAllObjects];
            [weakSelf.commentDataSource addObjectsFromArray: [CommentListData mj_objectArrayWithKeyValuesArray:responseData]];
            [weakSelf.mainTabView reloadData];
        }
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return _commentDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDetailTabCell *cell ;
    if (indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"titleDetailTabCell"];
        cell.timeLab.text = [NSString stringWithFormat:@"%@发布",[Utils getTimeStrToCurrentDateWith:_dataModel.createTime]];
        cell.contentLab.text = _dataModel.content;
        cell.nameLab.text = _dataModel.nickName;
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:_dataModel.avatar] placeholderImage:DefaultImage];
        if (_dataModel.image.length==0) {
            cell.contentImgH.constant = 0;
        }
        else {
            [cell.contentImgView sd_setImageWithURL:[NSURL URLWithString:_dataModel.image] placeholderImage:DefaultImage];
        }
    }
    else if (indexPath.section==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"commentDetailTabCell"];
        CommentListData *model = _commentDataSource[indexPath.row];
        cell.commentNameLab.text = model.nickName;
        cell.timeLab.text = [NSString stringWithFormat:@"%@发布",[Utils getTimeStrToCurrentDateWith:model.createTime]];
//        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:DefaultImage];
        cell.commentContentLab.text = model.comment;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

/*
#pragma mark - Navigation
 */

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"presentComment"]) {
        __weak typeof(self) weakSelf = self;
        JSSendCommentVC *vc = segue.destinationViewController;
        vc.postId = _dataModel.ID;
        vc.doneBlock = ^{
            [weakSelf getCommentData];
        };
    }
}

- (IBAction)followBtnClickAction:(UIButton *)sender {
}
@end

@implementation TopicDetailTabCell

@end

@implementation CommentListData

@end
