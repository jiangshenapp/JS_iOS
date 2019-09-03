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
@end

@implementation JSTopicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDetailTabCell *cell ;
    if (indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"titleDetailTabCell"];
    }
    else if (indexPath.section==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"commentDetailTabCell"];
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
        JSSendCommentVC *vc = segue.destinationViewController;
    }
}

- (IBAction)followBtnClickAction:(UIButton *)sender {
}
@end

@implementation TopicDetailTabCell

@end
