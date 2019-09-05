//
//  JSParkAddressVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/9/5.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSParkAddressVC.h"
#import "MOFSPickerManager.h"

@interface JSParkAddressVC ()

/** <#object#> */
@property (nonatomic,copy) NSString *currentProvince;
/** <#object#> */
@property (nonatomic,copy) NSString *currentCity;
/** <#object#> */
@property (nonatomic,copy) NSString *currentArea;
/** <#object#> */
@property (nonatomic,copy) NSString *currentCode;

@property (weak, nonatomic) IBOutlet UITextField *contactNameTF;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTF;
@property (weak, nonatomic) IBOutlet UILabel *parkAddressLab;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressLab;
- (IBAction)selectParkAddressAction:(UIButton *)sender;
/** 4个选择图片的方法 tag= 100,101,102,103 */
- (IBAction)selectPhotoAction:(UIButton *)sender;

- (IBAction)submitCheckAction:(UIButton *)sender;


@end

@implementation JSParkAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"园区地址";
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectParkAddressAction:(UIButton *)sender {
    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:@"选择地址" cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
        NSArray *arrAddress = [address componentsSeparatedByString:@"-"];
        NSArray *arrCode = [zipcode componentsSeparatedByString:@"-"];
        self.currentProvince = arrAddress[0];
        self.currentCity = arrAddress[1];
        self.currentArea = arrAddress[2];
        self.currentCode = arrCode[2];
        self.parkAddressLab.textColor = [UIColor blackColor];
        self.parkAddressLab.text = [NSString stringWithFormat:@"%@%@%@", self.currentProvince, self.currentCity, self.currentArea];
    } cancelBlock:^{
        
    }];
}

- (IBAction)selectPhotoAction:(UIButton *)sender {
}

- (IBAction)submitCheckAction:(UIButton *)sender {
}
@end
