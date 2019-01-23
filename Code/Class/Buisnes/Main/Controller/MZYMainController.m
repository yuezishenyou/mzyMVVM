//
//  MZYMainController.m
//  mzyMVVM
//
//  Created by 杨广军 on 2018/12/24.
//  Copyright © 2018 maoziyue. All rights reserved.
//

#import "MZYMainController.h"
#import "MZYMainView.h"
#import "MZYMainViewModel.h"

#import "MZYNextController.h"


@interface MZYMainController ()

@property (nonatomic, strong) MZYMainView *mainView;

@property (nonatomic, strong) MZYMainViewModel *viewModel;

@end

@implementation MZYMainController

- (void)dealloc {
    
    NSLog(@"---------MZYMainController 释放------------");
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    self.title = @"主页";
    
    
    

    [self configUI];
    
    
    [self bindViewModel];
    
}

- (void)configUI {
    
    [self.view addSubview:self.mainView];
    self.mainView.backgroundColor = [UIColor yellowColor];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
}


- (void)bindViewModel {
    

    @weakify(self);
    [[self.viewModel.cellSelectSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        //NSLog(@"--------cell点击事件:%@---------",x);
        
        MZYNextController *vc = [[MZYNextController alloc] init];
        
        vc.dict = x;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
   
}




#pragma mark ------------------ lazy -----------------------

- (MZYMainView *)mainView {
    
    if (!_mainView) {
        _mainView = [[MZYMainView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (MZYMainViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[MZYMainViewModel alloc] init];
    }
    return _viewModel;
}




















@end
