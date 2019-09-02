//
//  JSSearchCircleVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSearchCircleVC.h"
#import "CircleListTabCell.h"

@interface JSSearchCircleVC ()

@end

@implementation JSSearchCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找圈子";
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 34)];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 20, 20)];
    img.image = [UIImage imageNamed:@"equipment_icon_search_gray"];
    [view addSubview:img];
    self.searchTF.leftView = view;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCircleTabCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [Utils getViewController:@"Community" WithVCName:@"JSCircleContentVC"];
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
