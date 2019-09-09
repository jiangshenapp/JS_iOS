//
//  RequestURLUtil.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/9.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "RequestURLUtil.h"

@implementation RequestURLUtil

+ (void)postImageWithData:(UIImage *)image result:(void(^)(NSString *imageID))result {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
    NSMutableArray *imageDataArr = [NSMutableArray arrayWithObjects:imageData, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pigx",@"resourceId", nil];
    [[NetworkManager sharedManager] postJSON:URL_FileUpload parameters:dic imageDataArr:imageDataArr imageName:@"file" completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            NSString *photo = responseData;
            if (result) {
                result(photo);
            }
        }
    }];
}
@end
