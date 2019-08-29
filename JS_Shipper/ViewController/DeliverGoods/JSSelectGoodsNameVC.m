//
//  JSSelectGoodsNameVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/24.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSelectGoodsNameVC.h"
#import "AEFlowLayoutView.h"

@interface JSSelectGoodsNameVC ()<AEFlowLayoutViewDelegate>

/** 货物名称/包装类型 */
@property (nonatomic,retain) NSMutableArray *goodsNameArr;

@end

@implementation JSSelectGoodsNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_sourceType==0) {
        self.title = @"货物名称";
        self.nameTF.placeholder = @"在此输入货物名称";
    }
    else if (_sourceType==1) {
        self.title = @"包装类型";
        self.nameTF.placeholder = @"在此输入包装类型";
    }
    self.nameTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.goodsNameArr = [NSMutableArray array];
    [self getData];
}

#pragma mark - get data
- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?type=%@",URL_GetDictByType,_sourceType==0?@"goodsName":@"packType"];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            NSArray *arr = responseData;
            if ([arr isKindOfClass:[NSArray class]]) {
                for (int i = 0; i<arr.count; i++) {
                    [weakSelf.goodsNameArr addObject:arr[i][@"label"]];
                }
                AEFlowLayoutView *hisFlowView = [[AEFlowLayoutView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)]; //高度由内容定
                hisFlowView.array = weakSelf.goodsNameArr;
                hisFlowView.delegate = self;
                [weakSelf.nameView addSubview:hisFlowView];
                weakSelf.viewH.constant = hisFlowView.height;
            }
        }
    }];
}

#pragma mark - AEFlowLayoutViewDelegate
//常用点击
- (void)clickFlowLayout:(AEButton *)sender {
    NSLog(@"%@  %@",sender.idStr,sender.name);
    self.nameTF.text = sender.name;
}

- (IBAction)doneAction:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(self.nameTF.text);
    }
    [self backAction];
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
