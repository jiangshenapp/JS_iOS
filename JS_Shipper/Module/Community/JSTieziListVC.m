//
//  JSTieziListVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/4.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSTieziListVC.h"

@interface JSTieziListVC ()
/** 数据源1 */
@property (nonatomic,retain) NSMutableArray *dataSource1;
/** 数据源1 */
@property (nonatomic,retain) NSMutableArray *dataSource2;
/** 数据源1 */
@property (nonatomic,retain) NSMutableArray *dataSource3;

- (IBAction)titleBtnAction:(UIButton *)sender;
@end

@implementation JSTieziListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帖子列表";
    _dataSource1 = [NSMutableArray array];
    _dataSource2 = [NSMutableArray array];
    _dataSource3 = [NSMutableArray array];
    [self titleBtnAction:[self.view viewWithTag:100+_type]];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleContentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tieziListCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [Utils getViewController:@"Community" WithVCName:@"JSTopicDetailVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)titleBtnAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    for (NSInteger tag = 100; tag <103; tag++) {
        UIButton *tempBtn = [sender.superview viewWithTag:tag];
        if (![sender isEqual:tempBtn]) {
            tempBtn.selected = NO;
        }
    }
}
@end
