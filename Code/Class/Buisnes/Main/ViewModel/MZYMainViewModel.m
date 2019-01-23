//
//  MZYMainViewModel.m
//  mzyMVVM
//
//  Created by 杨广军 on 2018/12/24.
//  Copyright © 2018 maoziyue. All rights reserved.
//

#import "MZYMainViewModel.h"

@interface MZYMainViewModel ()

@property (nonatomic, assign) NSInteger currentPage;


@end

@implementation MZYMainViewModel

- (void)dealloc {
    NSLog(@"-------MZYMainViewModel 释放--------");
}


- (void)yd_initialize {
    
//    RACSubject *sub1 = [RACSubject subject];
//
//    [[[sub1 skip:3] take:1] subscribeNext:^(id x) {
//        NSLog(@"------x:%@-------",x);
//    }];
//
//    [sub1 sendNext:@"1"];
//    [sub1 sendNext:@"2"];
//    [sub1 sendNext:@"3"];
//    [sub1 sendNext:@"4"];
//    [sub1 sendNext:@"5"];
//    [sub1 sendNext:@"6"];
//    [sub1 sendNext:@"7"];
//    [sub1 sendNext:@"8"];
    
    
    
    
    
    
    @weakify(self);
    [[[self.refreshDataCommand.executing skip:1] take:1] subscribeNext:^(id x) {

        NSLog(@"-------正在加载------");
        
        if ([x isEqualToNumber:@(YES)]) {
            [DejActivityView activityViewWithLabel:@"加载中..."];
        }
        
    }];
    
    
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        
        //NSLog(@"-----------命令:%@-------------",x);
        self.dataSource = [[NSMutableArray alloc] initWithArray:x];
        
        [self.refreshEndSubject sendNext:nil];
        
        [DejActivityView removeView];
    }];
    
    


    
    
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
  
        NSArray *arr = (NSArray *)x;
        for (NSDictionary *dic in arr) {
            [self.dataSource addObject:dic];
        }
        
        
        [self.refreshEndSubject sendNext:nil];
        
        [DejActivityView removeView];
    }];
    
}










#pragma mark --------- lazy --------------
- (RACSubject *)cellSelectSubject {
    
    if (!_cellSelectSubject) {
        _cellSelectSubject = [RACSubject subject];
    }
    return _cellSelectSubject;
}

- (RACSubject *)refreshEndSubject {
    
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)refreshUISubject {
    
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}

- (RACCommand *)refreshDataCommand {
    
    if (!_refreshDataCommand) {
        
        @weakify(self);
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                
                NSLog(@"------网络请求 下拉刷新--------");
//                NSString *url = [NSString stringWithFormat:@"dddd"];
//                [DejNetwork POST:url parameters:nil success:^(id responseBody) {
//
//
//                    [subscriber sendCompleted];
//                } failure:^(NSError *error) {
//
//                    [subscriber sendNext:nil];
//                    [subscriber sendCompleted];
//                }];
                
                
                self.currentPage = 0;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    //NSDictionary *dict = [responseString objectFromJSONString];
                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 10; i++) {
                        NSString *age = [NSString stringWithFormat:@"%d",i];
                        NSDictionary *dict = @{
                                               @"name":@"maoziyue",
                                               @"age":age,
                                               };
                        [dataArray addObject:dict];
                    }
                    [subscriber sendNext:dataArray];
                    [subscriber sendCompleted];
                });

                return nil;
            }];
        }];
    }
    return _refreshDataCommand;
}


- (RACCommand *)nextPageCommand {
    
    if (!_nextPageCommand) {
        
        @weakify(self);
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                NSLog(@"------网络请求 上拉加载更多--------");
                
//                NSString *url = [NSString stringWithFormat:@"dddd"];
//                [DejNetwork POST:url parameters:nil success:^(id responseBody) {
//                    [subscriber sendCompleted];
//                } failure:^(NSError *error) {
//
//                    //self.currentPage --;
//                    //ShowErrorStatus(@"网络连接失败");
//                    [subscriber sendCompleted];
//                }];
                
                
                self.currentPage ++;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 10; i++) {
                        NSString *age = [NSString stringWithFormat:@"%d-page%ld",i,(long)self.currentPage];
                        NSDictionary *dict = @{
                                               @"name":@"maoziyue",
                                               @"age":age,
                                               };
                        [dataArray addObject:dict];
                    }
                    [subscriber sendNext:dataArray];
                    [subscriber sendCompleted];

                });
            
                return nil;
            }];
        }];
    }
    return _nextPageCommand;
}























@end
