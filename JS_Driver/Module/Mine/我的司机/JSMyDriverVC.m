
//
//  JSMyDriverVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyDriverVC.h"

@interface JSMyDriverVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
/** 司机列表 */
@property (nonatomic,retain) NSMutableArray *listData;
/** 司机信息 */
@property (nonatomic,retain) DriverModel *driverModel;
@end

@implementation JSMyDriverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的司机";
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [sender setTitle:@"添加司机" forState:UIControlStateNormal];
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:14];
    [sender addTarget:self action:@selector(addviewAction) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sender];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    image.image = [UIImage imageNamed:@"consignee_icon_name"];
    self.searchTF.leftView = image;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    [self getData];
    
    self.addPhoneTF.delegate = self;
    [self.addPhoneTF addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 根据手机号查找司机信息

- (void)textValueChanged {
    if (self.addPhoneTF.text.length == 11) {
        NSDictionary *dic = [NSDictionary dictionary];
        NSString *urlStr = [NSString stringWithFormat:@"%@?mobile=%@",URL_FindDriverByMobile,self.addPhoneTF.text];
        [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@",urlStr] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                self.driverModel = [DriverModel mj_objectWithKeyValues:(NSDictionary *)responseData];
                self.addNameTF.text = self.driverModel.driverName;
                self.addDriverTF.text = self.driverModel.driverLevel;
            } else {
                self.driverModel = nil;
                self.addNameTF.text = @"";
                self.addDriverTF.text = @"";
            }
        }];
    }
}

#pragma mark - 获取司机列表

- (void)getData {
    self.listData = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@",URL_Drivers] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            if ([responseData[@"records"] isKindOfClass:[NSArray class]]) {
                weakSelf.listData = [DriverModel mj_objectArrayWithKeyValuesArray:responseData[@"records"]];
                [weakSelf.baseTabView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"MyDriverTabCell";
    MyDriverTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[MyDriverTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    DriverModel *model = self.listData[indexPath.row];
    [cell setContentWithModel:model];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"解绑";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.baseTabView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.isSelect == YES) {
        if (self.selectDriverBlock) {
            DriverModel *model = self.listData[indexPath.row];
            self.selectDriverBlock(model);
            [self backAction];
        }
    }
}

#pragma mark - 解绑司机

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *dic = [NSDictionary dictionary];
        DriverModel *model = self.listData[indexPath.row];
        NSString *urlStr = [NSString stringWithFormat:@"%@?driverId=%@",URL_UnBindDriver,model.driverId];
        [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"解绑成功"];
                [weakSelf getData];
            }
            [weakSelf.baseTabView reloadData];
        }];
    }
}

- (void)addviewAction {
    
    self.driverModel = nil;
    
    UIWindow *myWindow= [[[UIApplication sharedApplication] delegate] window];
    [myWindow addSubview:_addView];
    _addContentView.top = HEIGHT;
    _bgShdowView.alpha = 0.0;
    _addView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bgShdowView.alpha = 1.0;
        weakSelf.addContentView.center = CGPointMake(WIDTH/2.0, HEIGHT/2.0);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.addPhoneTF]) {
        if (textField.text.length + string.length > 11) {
            return NO;
        }
    }
    return YES;
}

- (IBAction)cancleAddAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bgShdowView.alpha = 0.0;
        weakSelf.addContentView.top = HEIGHT;;
    } completion:^(BOOL finished) {
        weakSelf.addView.hidden = YES;
    }];
}

#pragma mark - 添加司机

- (IBAction)addDriverAction:(id)sender {
    
    if ([Utils isBlankString:self.addPhoneTF.text]) {
        [Utils showToast:@"请输入手机号"];
        return;
    }
    if (![Utils validateMobile:self.addPhoneTF.text]) {
        [Utils showToast:@"手机号格式不正确"];
        return;
    }
    if ([Utils isBlankString:self.addNameTF.text]) {
        [Utils showToast:@"姓名不能为空"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?driverId=%@",URL_BindDriver,self.driverModel.driverId];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"添加成功"];
            [weakSelf cancleAddAction:nil];
            [weakSelf getData];
        }
        [weakSelf.baseTabView reloadData];
    }];
}

- (IBAction)cancleSearchAction:(UIButton *)sender {
    
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

@implementation MyDriverTabCell

- (void)setContentWithModel:(DriverModel *)model {
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"personalcenter_driver_icon_head_land"]];
    self.nameLab.text = model.driverName;
    self.starView.starScore = model.score;
    self.phoneLab.text = model.driverPhone;
    self.driverTypeLab.text = [NSString stringWithFormat:@"驾照类型：%@",model.driverLevel];
}

@end
