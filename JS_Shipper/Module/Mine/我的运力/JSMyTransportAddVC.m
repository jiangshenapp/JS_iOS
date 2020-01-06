//
//  JSMyTransportAddVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/6.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import "JSMyTransportAddVC.h"
#import "JSMyTransportVC.h"

@interface JSMyTransportAddVC ()
- (IBAction)searchActionClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mainTab;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@end

@implementation JSMyTransportAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchTF.borderWidth = 1;
    _searchTF.borderColor = RGBValue(0x979797);
    self.title = @"添加合作运力";
    _searchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 20)];
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSMyTransportTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSMyTransportAddTabCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)searchActionClick:(UIButton *)sender {
}
@end
