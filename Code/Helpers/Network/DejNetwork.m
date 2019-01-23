//
//  DejNetwork.m
//  Briefing
//
//  Created by maoziyue on 2017/9/22.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "DejNetwork.h"
#import "AFNetworking.h"


typedef NSURLSessionTask DejURLSessionTask;

static NSMutableArray *sg_requestTasks;

@interface DejNetwork ()

@property (nonatomic,strong)AFHTTPSessionManager *sessionManager;

@end

@implementation DejNetwork

/**
 * 单例  这个是json格式的
 */
+ (instancetype)manager
{
    static DejNetwork *_netWork = nil;
    if (_netWork == nil) {
        _netWork = [[DejNetwork alloc]init];
        _netWork.sessionManager = [AFHTTPSessionManager manager];
        
        _netWork.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _netWork.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
        
        _netWork.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_netWork.sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _netWork.sessionManager.requestSerializer.timeoutInterval = 10.f;  //
        [_netWork.sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
    
        //[_netWork.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        
    }
    return _netWork;
}




/**
 * POST方法
 * 类方法请求网络
 */
+ (void)POST:(NSString *)urlStr
  parameters:(NSDictionary *)parameters
     success:(successBlock)success
     failure:(failureBlock)failure
{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //DLog(@"-------请求的接口:%@---------",urlStr);
    
    __block DejNetwork *manager = [DejNetwork manager];
    [manager.sessionManager POST:urlStr
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         success(json);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"------xxxerror:%@-----",error);
         failure(error);
     }];
}













/**
 * GET方法
 * 实例方法请求网络
 */
//- (void)GET:(NSString *)urlStr
// parameters:(NSDictionary *)paramenters
//    success:(successBlock)success
//    failure:(failureBlock)failure
//{
//    //urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//    [self.sessionManager GET:urlStr
//                  parameters:paramenters
//                    progress:nil
//                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
//     {
//         id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//
//         success(json);
//
//
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         failure(error);
//     }];
//}


/**
 * GET方法
 * 类方法请求网络
 */
//+ (void)GET:(NSString *)urlStr
// parameters:(NSDictionary *)parameters
//    success:(successBlock)success
//    failure:(failureBlock)failure
//{
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    DLog(@"------urlStr:%@-----",urlStr);
//
//    __block DejNetwork *manager = [DejNetwork manager];
//    [manager.sessionManager GET:urlStr
//                     parameters:parameters
//                       progress:nil
//                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
//     {
//         id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//         DLog(@"------json:%@-----",json);
//         success(json);
//
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         DLog(@"------xxxerror:%@-----",error);
//         failure(error);
//     }];
//}

/**
 * POST方法
 * 实例方法请求网络
 */
//- (void)POST:(NSString *)urlStr
//  parameters:(NSDictionary *)parameters
//     success:(successBlock)success
//     failure:(failureBlock)failure
//{
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//    [self.sessionManager POST:urlStr
//                   parameters:parameters
//                     progress:nil
//                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
//     {
//         id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//
//         success(json);
//         [self checkTokenVaild:json];
//
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         failure(error);
//     }];
//}





+ (void)POST:(NSString *)urlStr
  parameters:(NSDictionary *)parameters
       image:(UIImage *)image
        name:(NSString *)name
     success:(successBlock)success
     failure:(failureBlock)failure
{
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    __block DejNetwork *manager = [DejNetwork manager];
    
    [manager.sessionManager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *picture = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:picture name:name fileName:@"photo.jpg" mimeType:@"photo/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        success(json);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}













#pragma mark------------------------------------- token失效的问题 --------------------------------------------------------




//上传文件请求
- (void)upload:(NSString *)urlStr parameters:(NSDictionary *)parameters filePath:(NSString *)filePath name:(NSString *)name mimeType:(NSString *)mimeType progress:(loadProgress)progress success:(successBlock)success failure:(failureBlock)failure {
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    DejURLSessionTask *task = [self.sessionManager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *fileNameInServer = [filePath lastPathComponent];
        NSData *data =  [NSData dataWithContentsOfFile:filePath];
        if (data){
            [formData appendPartWithFileData:data name:name fileName:fileNameInServer mimeType:mimeType];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        [[self allTasks] removeObject:task];
        
        success(json);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allTasks] removeObject:task];
        failure(error);
        
    }];
    
    
    [task resume];
    
    if (task) {
        [[self allTasks] addObject:task];
    }
    
    
}





//下载请求(带有缓存)
- (void)download:(NSString *)urlStr saveInDir:(NSString *)saveInDir saveFileName:(NSString *)saveFileName progress:(void(^)(NSProgress *downProgress))progress success:(successBlock)success failure:(failureBlock)failure {
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (!saveInDir) {
        NSLog(@"请选择一个保存的地址");
        progress([NSProgress new]);
        return;
    }
    
    
    //判断是否有缓存
    NSString *fileName = [url lastPathComponent];
    if (saveFileName) {
        fileName = saveFileName;
    }
    
    NSString *cacheFilePath = [saveInDir stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:cacheFilePath]) {
        NSLog(@"打开缓存文件:\n%@",cacheFilePath);
        progress([NSProgress new]);
        success(cacheFilePath);
        return;
    }
    
    
    //没有缓存就下载
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *fileDir = [NSURL fileURLWithPath:saveInDir];
        NSString *aFileName = [response suggestedFilename];
        if (saveFileName) {
            aFileName = saveFileName;
        }
        NSURL *fileUrl = [fileDir URLByAppendingPathComponent:aFileName];
        return fileUrl;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSString *path = [filePath relativePath];
        NSLog(@"------下载文件到:\n%@-----------",path);
        if (error) {
            failure(error);
        }
        else {
            NSDictionary *attributes = [fm attributesOfItemAtPath:path error:nil];
            NSNumber *theFileSize = [attributes objectForKey:NSFileSize];
            if ([theFileSize floatValue] == 0) {
                
                //移除容量大小为0的文件
                [fm removeItemAtPath:path error:nil];
                NSLog(@"-----下载的文件容量是0已移除------");
                NSDictionary *dict = @{@"msg":@"文件大小有问题",
                                       @"code":@(1)};
                NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:1 userInfo:dict];
                failure(err);
            }
            else {
                success([filePath relativePath]);
            }
        }
        
        
    }];
    
    [downloadTask resume];
    
    
}


- (void)cancelAllRequest {
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(DejURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[DejURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

- (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(DejURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[DejURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}




- (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sg_requestTasks == nil) {
            sg_requestTasks = [[NSMutableArray alloc] init];
        }
    });
    return sg_requestTasks;
}





















@end
