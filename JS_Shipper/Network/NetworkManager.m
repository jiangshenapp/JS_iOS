//
//  NetworkManager.m
//  ArtEast
//
//  Created by yibao on 16/9/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking.h>
#import "Utils.h"
#import "XLGExternalTestTool.h"

#define TIMEOUT 20;

static NetworkManager *_manager = nil;

@implementation NetworkManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:ROOT_URL()]];
    });
    return _manager;
}

- (void)postJSON:(NSString *)name
      parameters:(NSDictionary *)parameters
      completion:(RequestCompletion)completion {
    
//    if (![Utils getNetStatus]) {
//        [Utils showToast:@"检测到您的网络异常，请检查网络"];
//        return;
//    }
    
    [self configNetManager];
    
    if (![name containsString:@"http"]) {
        name = [NSString stringWithFormat:@"%@%@",ROOT_URL(),name];
    }
    name = [name urlEncoding];
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (![NSString isEmpty:[UserInfo share].token]) {
        [postDic setObject:[UserInfo share].token forKey:@"token"];
    }
    [self POST:name parameters:postDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [JHHJView hideLoading]; //结束加载
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        id _Nullable object = [NSDictionary changeType:responseObject];
        [self printLogInfoWith:name WithParam:parameters andResult:object];
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        NSString *code = [NSString stringWithFormat:@"%@",object[@"code"]];
        if ([code isEqualToString:@"0"]) { //成功
            id _Nullable dataObject = object[@"data"];
            completion(dataObject,Request_Success,nil);
            if ([dataObject isKindOfClass:[NSDictionary class]]) {//打印model
                NSArray *arr = dataObject[@"records"];
                if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
//                    [self printDataToModel:arr[0]];
                }
            }
        }
        else if ([code isEqualToString:@"-1"]) { //用户未登录
            [self reLogin];
        }
        else {
            completion(object,Request_Fail,nil);
            if (![Utils isBlankString:object[@"msg"]]
                && ![name containsString:URL_WxCodeLogin]
                && ![name containsString:URL_BindingWxInfo]) {
                [Utils showToast:object[@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        completion(nil,Request_TimeoOut,error);
        [self printLogInfoWith:name WithParam:parameters andResult:[error localizedDescription]];
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

- (void)getJSON:(NSString *)name
     parameters:(NSDictionary *)parameters
     completion:(RequestCompletion)completion {
    
    if (![Utils getNetStatus]) {
        [Utils showToast:@"检测到您的网络异常，请检查网络"];
        return;
    }
    
    [self configNetManager];
    
    if (![name containsString:@"http"]) {
        name = [NSString stringWithFormat:@"%@%@",ROOT_URL(),name];
    }
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    [self GET:name parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [JHHJView hideLoading]; //结束加载
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        id _Nullable object = [NSDictionary changeType:responseObject];
        NSString *code = [NSString stringWithFormat:@"%@",object[@"code"]];
        if ([code isEqualToString:@"0"]) { //成功
            id _Nullable dataObject = object[@"data"];
            if ([dataObject isKindOfClass:[NSString class]]) {
                completion(@"",Request_Success,nil);
            } else {
                completion(dataObject,Request_Success,nil);
            }
        }
        else if ([code isEqualToString:@"-1"]) { //用户未登录
            [self reLogin];
        }
        else {
            completion(nil,Request_Fail,nil);
            if (![Utils isBlankString:object[@"msg"]]) {
                [Utils showToast:object[@"msg"]];
            }
        }
        [self printLogInfoWith:name WithParam:parameters andResult:object];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        completion(nil,Request_TimeoOut,error);
        [self printLogInfoWith:name WithParam:parameters andResult:[error localizedDescription]];
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

- (void)postJSON:(NSString *)name
      parameters:(NSDictionary *)parameters
      imageDataArr:(NSMutableArray *)imgDataArr
       imageName:(NSString *)imageName
      completion:(RequestCompletion)completion {
    
    if (![Utils getNetStatus]) {
        [Utils showToast:@"检测到您的网络异常，请检查网络"];
        return;
    }
    
    [self configNetManager];
    
    if (![name containsString:@"http"]) {
        name = [NSString stringWithFormat:@"%@%@",ROOT_URL(),name];
    }
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    [self POST:name parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imgDataArr.count > 0) {
            //在网络开发中，上传文件时，是文件不允许被覆盖，文件重名。要解决此问题，可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [formatter stringFromDate:[NSDate date]];
            
            for (int i = 0; i<imgDataArr.count; i++) {
                NSData *data = (NSData *)imgDataArr[i];
                if (data != NULL) {
                    [formData appendPartWithFileData:data name:imageName fileName:[NSString stringWithFormat:@"%@%d.png",fileName,i] mimeType:@"image/png"];
                }
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [JHHJView hideLoading]; //结束加载
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        id _Nullable object = [NSDictionary changeType:responseObject];
        [self printLogInfoWith:name WithParam:parameters andResult:object];
        
        NSString *code = [NSString stringWithFormat:@"%@",object[@"code"]];
        if ([code isEqualToString:@"0"]) { //成功
            id _Nullable dataObject = object[@"data"];
            completion(dataObject,Request_Success,nil);
        }
        else if ([code isEqualToString:@"-1"]) { //用户未登录
            [self reLogin];
        }
        else {
            completion(object,Request_Fail,nil);
            if (![Utils isBlankString:object[@"msg"]]) {
                [Utils showToast:object[@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        completion(nil,Request_TimeoOut,error);
        [self printLogInfoWith:name WithParam:parameters andResult:[error localizedDescription]];
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

- (void)printLogInfoWith:(NSString *)url WithParam:(id)param andResult:(id)result {
    NSLog(@"%@",[NSString stringWithFormat:@"时间：%@\n参数：%@ \n %@\n返回结果：%@",[Utils getCurrentDate],url,[param jsonPrettyStringEncoded],[result isKindOfClass:[NSDictionary class]]?[result jsonPrettyStringEncoded]:result]);
    if (!KOnline) {
        XLGExternalTestTool *tool = [XLGExternalTestTool shareInstance];
        tool.logTextViews.text = [NSString stringWithFormat:@"时间：%@\n参数：%@ \n %@\n返回结果：%@ \n\n\n%@",[Utils getCurrentDate],url,param,result,tool.logTextViews.text];
    }
}

//配置请求头
- (void)configNetManager {
    //请求
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = TIMEOUT;
    //响应
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    //response.removesKeysWithNullValues = YES;
    self.responseSerializer = response;
    self.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/json", @"application/json", nil];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if ([Utils isLoginWithJump:NO]) {
        NSLog(@"token值：%@",[UserInfo share].token);
        [self.requestSerializer setValue:[UserInfo share].token forHTTPHeaderField:@"token"];
    }
}

//token失效判断
- (BOOL)isTokenInvalid:(int)statusCode {
    if (statusCode==401) { //token失效或者账号在其它地方登录
        [self reLogin];
        return YES;
    } else {
        return NO;
    }
}

// 重新登录
- (void)reLogin {
//    [Utils showToast:@"登录失效，请重新登录"];
    [[UserInfo share] setUserInfo:nil]; //清除用户信息
    //跳转到登录页
    [Utils isLoginWithJump:YES];
    [JHHJView hideLoading]; //结束加载
}

#pragma mark - 把输出的参数打印成model
/** 把输出的参数打印成model */
- (void)printDataToModel:(id)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = data;
        NSString *dataStr = @"";
        for (NSString *key in dataDic.allKeys) {
            id values = dataDic[key];
            NSString *type = @"NSString";
            NSString *prType = @"copy";
            if ([values isKindOfClass:[NSDictionary class]]) {
                type = @"NSDictionary";
                prType = @"retain";
            }
            else if ([values isKindOfClass:[NSArray class]]) {
                type = @"NSArray";
                prType = @"retain";
            }
            NSString *resulr = [NSString stringWithFormat:@"/** %@ */\n@property  (nonatomic , %@) %@ *%@;\n",dataDic[key],prType,type,key];
            dataStr = [dataStr stringByAppendingString:resulr];
        }
        if (dataStr.length>0) {
            NSLog(@"\n打印开始------------\n\n%@\n\n打印结束------------",dataStr);
        }
    }
    else if ([data isKindOfClass:[NSArray class]]) {
        NSArray *dataArr = data;
        if ([dataArr count] > 0) {
            [self printDataToModel:[dataArr firstObject]];
        }
    }
}

@end
