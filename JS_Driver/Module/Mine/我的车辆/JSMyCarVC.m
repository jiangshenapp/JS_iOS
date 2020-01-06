//
//  JSMyCarVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyCarVC.h"
#import "JSAddCarVC.h"
#import "CarModel.h"

@interface JSMyCarVC ()

/** 车辆列表 */
@property (nonatomic,retain) NSMutableArray <CarModel *> *listData;

@end

@implementation JSMyCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的车辆";
    
    self.view.backgroundColor = PageColor;
    
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [sender setTitle:@"添加车辆" forState:UIControlStateNormal];
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:14];
    [sender addTarget:self action:@selector(addCarAction) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sender];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 16, 16)];
    image.image = [UIImage imageNamed:@"app_search_icon_small"];
    self.searchTF.leftView = image;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:kAddCarSuccNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:kDeleteCarSuccNotification object:nil];
}

-(void)getData {
    self.listData = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@",URL_CarList] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            if ([responseData[@"records"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = [CarModel mj_objectArrayWithKeyValuesArray:responseData[@"records"]];
                [weakSelf.listData addObjectsFromArray:arr];
            }
        }
        [weakSelf.baseTabView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCarTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCarTabCell"];
    CarModel *model = self.listData[indexPath.row];
    cell.carNumLab.text = model.cphm;
    NSDictionary *dic = @{@"0":@"待审核",@"1":@"审核已通过",@"2":@"审核未通过",@"3":@"审核中"};
    NSDictionary *dicColor = @{@"0":RGBValue(0xECA73F),@"1":RGBValue(0x4A90E2 ),@"2":RGBValue(0xD0021B),@"3":RGBValue(0xECA73F)};
    cell.checkStateLab.text = dic[[NSString stringWithFormat:@"%@",model.state]];
    cell.checkStateLab.textColor = dicColor[[NSString stringWithFormat:@"%@",model.state]];
    [cell.carImgView sd_setImageWithURL:[NSURL URLWithString:model.image2] placeholderImage:DefaultImage];
    cell.typeLab.text = [NSString stringWithFormat:@"%@ %@米/%@方/%@吨",model.carModelName,model.carLengthName,model.capacityVolume,model.capacityTonnage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    if (self.isSelect == YES) {
        if (self.selectCarBlock) {
            CarModel *model = self.listData[indexPath.row];
            self.selectCarBlock(model);
            [self backAction];
        }
    } else {
        CarModel *model = self.listData[indexPath.row];
        JSAddCarVC *vc = (JSAddCarVC *)[Utils getViewController:@"Mine" WithVCName:@"JSAddCarVC"];
        vc.carDetailID = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addCarAction {
    JSAddCarVC *vc = (JSAddCarVC *)[Utils getViewController:@"Mine" WithVCName:@"JSAddCarVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cancleSearchTF:(UIButton *)sender {
    
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

@implementation MyCarTabCell

@end
