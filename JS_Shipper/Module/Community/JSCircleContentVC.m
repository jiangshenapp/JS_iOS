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
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleContentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CircleContentTabCell"];
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


@implementation CircleContentTabCell


@end
