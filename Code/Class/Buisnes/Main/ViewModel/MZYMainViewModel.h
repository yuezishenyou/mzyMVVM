//
//  MZYMainViewModel.h
//  mzyMVVM
//
//  Created by 杨广军 on 2018/12/24.
//  Copyright © 2018 maoziyue. All rights reserved.
//

#import "YDViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZYMainViewModel : YDViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshUISubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACSubject *cellSelectSubject; //cell点击事件

@property (nonatomic, strong) NSMutableArray *dataSource; //

















@end

NS_ASSUME_NONNULL_END
