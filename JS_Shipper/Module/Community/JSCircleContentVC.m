//
//  JSCircleContentVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSCircleContentVC.h"

@interface JSCircleContentVC ()

@end

@implementation JSCircleContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XXX的圈子";
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    // Do any additional setup after loading the view.
}

- (void)pushVC {
    UIViewController *vc = [Utils getViewController:@"Community" WithVCName:@"JSManagerCircleVC"];
    [self.navigationController pushViewController:vc animated:YES];}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleContentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleContentTabCell"];
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

@end


@implementation CircleContentTabCell


@end
