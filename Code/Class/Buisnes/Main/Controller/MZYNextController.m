//
//  MZYNextController.m
//  mzyMVVM
//
//  Created by 杨广军 on 2018/12/25.
//  Copyright © 2018 maoziyue. All rights reserved.
//

#import "MZYNextController.h"

@interface MZYNextController ()


@property (weak, nonatomic) IBOutlet UILabel *descLabel;



@end

@implementation MZYNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"--next--";
    

    NSString *name = self.dict[@"name"];
    NSString *age = self.dict[@"age"];

    self.descLabel.text = [NSString stringWithFormat:@"%@(%@)",name,age];
    
}













@end
