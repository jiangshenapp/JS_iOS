//
//  JSChangeOrderDetailVC.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/16.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSChangeOrderDetailVC.h"

@interface JSChangeOrderDetailVC ()<UIActionSheetDelegate>

@end

@implementation JSChangeOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改订单信息";
    
    [self initView];
}

#pragma mark - init view

- (void)initView {
    NSInteger state = [self.model.state integerValue];
    if (state == 4) { //3、待司机确认，修改支付信息、收货人信息；4、待支付，修改收货人信息；
        self.feeH.constant = 0;
        self.payTypeH.constant = 0;
        self.paymentTypeH.constant = 0;
    } else {
        if ([self.model.payWay isEqualToString:@"1"]) {
            self.payTypeLab.text = @"线上支付";
        } else {
            self.payTypeLab.text = @"线下支付";
        }
        if ([self.model.feeType isEqualToString:@"1"]) {
            self.feeTF.text = self.model.fee;
        } else {
            self.feeTF.text = @"";
        }
        if ([self.model.payType isEqualToString:@"1"]) {
            self.paymentTypeLab.text = @"到付";
        } else {
            self.paymentTypeLab.text = @"现付";
        }
    }
    self.nameTF.text = self.model.receiveName;
    self.phoneTF.text = self.model.receiveMobile;
}

#pragma mark - methods

/** 支付方式 */
- (IBAction)payTypeAction:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"关闭" destructiveButtonTitle:nil otherButtonTitles:@"在线支付",@"线下支付", nil];
    sheet.tag = 101;
    [sheet showInView:self.view];
}

/** 付款方式 */
- (IBAction)paymentTypeAction:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"关闭" destructiveButtonTitle:nil otherButtonTitles:@"到付",@"现付", nil];
    sheet.tag = 102;
    [sheet showInView:self.view];
}

/** 修改 */
- (IBAction)changeAction:(id)sender {
    
    if ([self.model.state integerValue] == 3) {
        if ([Utils isBlankString:_feeTF.text]) {
            [Utils showToast:@"请填写运费"];
            return;
        }
        if ([Utils isBlankString:_payTypeLab.text]) {
            [Utils showToast:@"请选择支付方式"];
            return;
        }
        if ([Utils isBlankString:_paymentTypeLab.text]) {
            [Utils showToast:@"请选择付款方式"];
            return;
        }
    }
    if ([Utils isBlankString:_nameTF.text]) {
        [Utils showToast:@"请填写收货人"];
        return;
    }
    if ([Utils isBlankString:_phoneTF.text]) {
        [Utils showToast:@"请填写联系方式"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_nameTF.text forKey:@"receiveName"];
    [dic setObject:_phoneTF.text forKey:@"receiveMobile"];
    if ([self.model.state integerValue] == 3) {
        [dic setObject:_feeTF.text forKey:@"fee"];
        [dic setObject:[_paymentTypeLab.text isEqualToString:@"到付"]?@"1":@"2" forKey:@"payType"];
        [dic setObject:[_payTypeLab.text isEqualToString:@"线上支付"]?@"1":@"2" forKey:@"payWay"];
    }
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_EditOrderDetail,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"修改成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = actionSheet.tag;
    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"关闭"]) {
        if (tag == 101) { //支付方式
            self.payTypeLab.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        }
        if (tag == 102) { //付款方式
            self.paymentTypeLab.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        }
    }
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
