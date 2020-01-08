

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
@end

@implementation JSSysMsgDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SysMsgDetailTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysMsgDetailTabCell"];
    cell.imgH.constant = 0;
    cell.contentTopH = 0;
    if (self.sysModel) {
       cell.titleLab.text = _sysModel.title;
       cell.contendLab.text = _sysModel.content;
       cell.timeLab.text = _sysModel.publishTime;
       if (_sysModel.image.length>0) {
           cell.imgH.constant = 200;
           cell.contentTopH.constant = 10;
           [cell.imgBtn sd_setImageWithURL:[NSURL URLWithString:_sysModel.image] forState:UIControlStateNormal placeholderImage:DefaultImage];
       }
    }
    else {
        cell.titleLab.text = _pushModel.templateName;
        cell.contendLab.text = _pushModel.pushContent;
        cell.timeLab.text = _pushModel.pushTime;
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
