//
//  JSPublishTopicVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSendTopicVC.h"
#import "NSString+NOEmoji.h"
#import "TZImagePickerController.h"
#import "RequestURLUtil.h"

@interface JSSendTopicVC ()<TZImagePickerControllerDelegate>
{
    NSString *subjectID;
}
/** 图片 */
@property (nonatomic,copy)     NSString *imageID;;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
- (IBAction)addImageAction:(UIButton *)sender;
- (IBAction)sendTopicAction:(UIButton *)sender;

@end

@implementation JSSendTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发帖";
    subjectID = @"1";
    if (_circleId.length==0) {
        _circleId = @"1";
    }
    _imageID = @"";
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

- (IBAction)addImageAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];;
    vc.naviTitleColor = kBlackColor;
    vc.barItemTextColor = AppThemeColor;
    vc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
            UIImage *firstimg = [photos firstObject];
            [sender setImage:firstimg forState:UIControlStateNormal];
            [RequestURLUtil postImageWithData:firstimg result:^(NSString * _Nonnull imageID) {
                weakSelf.imageID = imageID;
            }];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)sendTopicAction:(UIButton *)sender {
    NSString *content = _contentTV.text;
    content = [content noEmoji];
    if (content.length==0) {
        if (_contentTV.text.length>0) {
            [Utils showToast:@"请输入合法字符串"];
            return;
        }
        [Utils showToast:@"请填写内容"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?circleId=%@&content=%@&subject=%@&image=%@",URL_PostAdd,_circleId,_contentTV.text,subjectID,_imageID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"发布成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}
@end
