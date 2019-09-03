//
//  JSManagerCircleVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSManagerCircleVC.h"

@interface JSManagerCircleVC ()

@end

@implementation JSManagerCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"圈子名称";
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerCircleTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerCircleTabCell"];
    return cell;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakself = self;
    
    void(^deleteActionBlock)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
    };
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:deleteActionBlock];
    deleteAction.backgroundColor = [UIColor colorWithHexString:@"ff4545"];
    
    
    void(^agreeActionBlock)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"同意");
    };
    UITableViewRowAction *agreeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"同意" handler:agreeActionBlock];
    
    agreeAction.backgroundColor = [UIColor colorWithHexString:@"ffa902"];
    
    
    void(^refuseActionBlock)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"拒绝");
    };
    
    UITableViewRowAction *refuseAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"拒绝" handler:refuseActionBlock];
    refuseAction.backgroundColor = [UIColor blueColor];
    
    return @[deleteAction,agreeAction,refuseAction];
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

@implementation ManagerCircleTabCell

@end
