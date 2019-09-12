

//
//  JSSysMsgDetailVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/12.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSysMsgDetailVC.h"
#import "JSSystemMessageVC.h"
#import <UIButton+WebCache.h>

@interface JSSysMsgDetailVC ()
@property (nonatomic,retain) SysMessageModel *dataModel;
@end

@implementation JSSysMsgDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)getData {
    NSString *type = [AppChannel isEqualToString:@"1"]?@"3":@"2";
    type = @"1";
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_MessageDetail,_msgID];
    [[NetworkManager sharedManager] getJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.dataModel = [SysMessageModel mj_objectWithKeyValues:responseData];
        }
        [weakSelf.mainTabView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SysMsgDetailTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysMsgDetailTabCell"];
    cell.titleLab.text = _dataModel.title;
    cell.contendLab.text = _dataModel.content;
    cell.timeLab.text = _dataModel.createTime;
    cell.imgH.constant = _dataModel.image.length==0?0:140;
    if (_dataModel.image.length==0) {
        cell.imgH.constant = 0;
    }
    else {
    [cell.imgBtn sd_setImageWithURL:[NSURL URLWithString:_dataModel.image] forState:UIControlStateNormal placeholderImage:DefaultImage];
    }
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation SysMsgDetailTabCell

@end
