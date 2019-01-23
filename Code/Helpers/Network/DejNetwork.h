//
//  DejNetwork.h
//  Briefing
//
//  Created by maoziyue on 2017/9/22.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^successBlock)(id responseBody);
typedef void (^failureBlock)(NSError *error);
typedef void (^loadProgress)(int64_t bytesWritten, int64_t totalBytesWritten); //bytesWritten:已上传的大小,  totalBytesWritten:总上传大小

@interface DejNetwork : NSObject











//****************************** 基础 *******************************/



/**
 * 单例
 */
+ (instancetype)manager;



/**
 * POST方法
 * 类方法请求网络
 */
+ (void)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;












/**
 * GET方法
 * 实例方法请求网络
 */
//- (void)GET:(NSString *)urlStr parameters:(NSDictionary *)paramenters success:(successBlock)success failure:(failureBlock)failure;

/**
 * GET方法
 * 类方法请求网络
 */
//+ (void)GET:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;

/**
 * POST方法
 * 实例方法请求网络
 */
//- (void)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;







+ (void)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters image:(UIImage *)image name:(NSString *)name success:(successBlock)success failure:(failureBlock)failure;



//上传文件请求
- (void)upload:(NSString *)urlStr parameters:(NSDictionary *)parameters filePath:(NSString *)filePath name:(NSString *)name mimeType:(NSString *)mimeType progress:(loadProgress)progress success:(successBlock)success failure:(failureBlock)failure;





//下载请求(带有缓存)
- (void)download:(NSString *)urlStr saveInDir:(NSString *)saveInDir saveFileName:(NSString *)saveFileName progress:(void(^)(NSProgress *downProgress))progress success:(successBlock)success failure:(failureBlock)failure;






/**
 *  取消所有请求
 */
- (void)cancelAllRequest;




/**
 *  取消当个请求
 *  @param url URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
- (void)cancelRequestWithURL:(NSString *)url;










@end
