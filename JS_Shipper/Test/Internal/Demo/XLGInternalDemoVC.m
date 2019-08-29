//
//  XLGInternalDemoVC.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/14.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGInternalDemoVC.h"

#define cellHeight 40.0f

@interface XLGInternalDemoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *titleArr;

@end

@implementation XLGInternalDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo";
    
    [self initTab];
}

#pragma mark - init view

- (void)initTab {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.tableFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - lazy loading...

- (NSArray *)titleArr {
    if(_titleArr==nil) {
        _titleArr = @[@"H5交互"];
    }
    return _titleArr;
}

#pragma mark - UITableViewDelegate、UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    NSString *title = self.titleArr[indexPath.row];
    
    if ([title isEqualToString:@"H5交互"]) {
        
        [Utils showToast:@"H5交互"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
