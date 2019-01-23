//
//  ViewController.m
//  mzyMVVM
//
//  Created by 杨广军 on 2018/12/24.
//  Copyright © 2018 maoziyue. All rights reserved.
//

#import "ViewController.h"
#import "MZYMainController.h"

@interface ViewController ()




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timego) name:UIApplicationSignificantTimeChangeNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentTimego) name:NSCurrentLocaleDidChangeNotification object:nil];
    

    
    self.title = @"--vc--";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"进主页"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(rightClick)];
    
}

- (void)timego {
    
    NSLog(@"------timego-------");
    
}


- (void)currentTimego {
    
    NSLog(@"------currentTimego-------");
    
}










- (void)rightClick {
    
    MZYMainController *vc = [[MZYMainController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}















@end
