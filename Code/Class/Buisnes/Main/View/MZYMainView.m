//
//  MZYMainView.m
//  mzyMVVM
//
//  Created by 杨广军 on 2018/12/24.
//  Copyright © 2018 maoziyue. All rights reserved.
//

#import "MZYMainView.h"
#import "MZYTableCell.h"
#import "MZYMainViewModel.h"


@interface MZYMainView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) MZYMainViewModel *viewModel;

@property (nonatomic, strong) UITableView *tbView;

@end

@implementation MZYMainView

- (void)dealloc {
    NSLog(@"-------MZYMainView 释放--------");
}

- (instancetype)initWithViewModel:(id<YDViewModelProtocol>)viewModel {
    
    self.viewModel = (MZYMainViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
    
}





- (void)yd_setupViews {
    
    [self addSubview:self.tbView];
    
    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
}



- (void)yd_bindViewModel {
    
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self);
    [self.viewModel.refreshUISubject subscribeNext:^(id x) {
        
        @strongify(self);
        [self.tbView reloadData];
        [self.tbView.mj_header endRefreshing];
        [self.tbView.mj_footer endRefreshing];
        
        
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        
        @strongify(self);
        [self.tbView reloadData];
        [self.tbView.mj_header endRefreshing];
        [self.tbView.mj_footer endRefreshing];
        
        
        
    }];

    
}



#pragma mark -------------- tbView 代理 ---------------------------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZYTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZYTableCell"];
    NSDictionary *dict = self.viewModel.dataSource[indexPath.row];
    cell.dict = dict;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.viewModel.dataSource[indexPath.row];

    [self.viewModel.cellSelectSubject sendNext:dict];
    
    
}









#pragma mark ---------------- lazy -------------------

- (UITableView *)tbView {
    
    if (!_tbView) {
        _tbView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.rowHeight = 80;
        _tbView.separatorStyle = 0;
        
        [_tbView registerNib:[UINib nibWithNibName:@"MZYTableCell" bundle:nil] forCellReuseIdentifier:@"MZYTableCell"];
        
        @weakify(self);
        _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@"--------下拉刷新------------");
            [self.viewModel.refreshDataCommand execute:nil];
            
        }];
        
        
        _tbView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@"--------上拉加载更多--------");
            [self.viewModel.nextPageCommand execute:nil];
            
            
        }];
        
        _tbView.mj_footer.automaticallyChangeAlpha = YES;
        
    }
    return _tbView;
}









@end
