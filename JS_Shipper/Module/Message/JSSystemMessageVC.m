//
//  JSSystemMessageVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/9.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSSystemMessageVC.h"

@interface JSSystemMessageVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JSSystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    self.baseTabView.delegate = self;
    self.baseTabView.dataSource = self;
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SysMessageTabcell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysMessageTabcell"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *timelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    timelab.text = @"02-28 13:03";
    timelab.textAlignment = NSTextAlignmentCenter;
    timelab.textColor= RGBValue(0xB4B4B4);
    timelab.font = [UIFont systemFontOfSize:12];
    [view addSubview:timelab];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
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
@implementation SysMessageTabcell

@end
