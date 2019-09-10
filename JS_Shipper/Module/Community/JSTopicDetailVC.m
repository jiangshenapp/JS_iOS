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

@property (weak, nonatomic) IBOutlet UIImageView *circleImgView;
@property (weak, nonatomic) IBOutlet UILabel *circleNameLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
//关注
- (IBAction)attentionActionClick:(id)sender;
//点赞
- (IBAction)clickLikeAction:(UIButton *)sender;
@end

@implementation JSTopicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    _praiseNumLab.text = _dataModel.likeCount;
    _commentLab.text = _dataModel.commentCount;
    if ([_dataModel.likeFlag integerValue]==1) {
        _likeBtn.selected = YES;
    }
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
            weakSelf.commentLab.text = [NSString stringWithFormat:@"%ld",weakSelf.commentDataSource.count];
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
        [cell.commentHeadImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:DefaultImage];
        cell.commentContentLab.text = model.comment;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, autoScaleW(44))];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, view.width-36, view.height)];
        label.text = [NSString stringWithFormat:@"全部评论(%ld)",_commentDataSource.count];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        return view;
    }
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==1) {
        return autoScaleW(44);
    }
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

- (IBAction)attentionActionClick:(id)sender {
}

- (IBAction)clickLikeAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?postId=%@",URL_PostLike,_dataModel.ID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            weakSelf.praiseNumLab.text = [NSString stringWithFormat:@"%ld",[weakSelf.dataModel.likeCount integerValue]+1];
            sender.selected = YES;
            // 0.2 表示动画时长为0.2秒
            [UIView animateWithDuration:0.1 animations:^{
                sender.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    sender.imageView.transform = CGAffineTransformIdentity;
                }];
            }];
        }
    }];
}
@end

@implementation TopicDetailTabCell

@end

@implementation CommentListData

@end
