//
//  JSSendCommentVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSSendCommentVC.h"

@interface JSSendCommentVC ()
@property (weak, nonatomic) IBOutlet UITextView *commentTV;
- (IBAction)backAction:(UIButton *)sender;
- (IBAction)sendAction:(UIButton *)sender;

@end

@implementation JSSendCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
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

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendAction:(UIButton *)sender {
    NSString *content = _commentTV.text;
    content = [content noEmoji];
    if (content.length==0) {
        if (_commentTV.text.length>0) {
            [Utils showToast:@"请输入合法字符串"];
            return;
        }
        [Utils showToast:@"请填写内容"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?postId=%@&comment=%@",URL_PostComment,_postId,content];
    [dic setObject:content forKey:@"comment"];
    [dic setObject:_postId forKey:@"postId"];
    [[NetworkManager sharedManager] postJSON:URL_PostComment parameters:dic imageDataArr:nil imageName:@"" completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"评论成功"];
            [weakSelf backAction:nil];
            if (weakSelf.doneBlock) {
                weakSelf.doneBlock();
            }
        }
    }];

        
//    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
//        if (status==Request_Success) {
//            [Utils showToast:@"评论成功"];
//            [weakSelf backAction:nil];
//            if (weakSelf.doneBlock) {
//                weakSelf.doneBlock();
//            }
//        }
//    }];
}
@end
