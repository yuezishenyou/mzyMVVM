//
//  MZYTableCell.m
//  mzyMVVM
//
//  Created by 杨广军 on 2018/12/25.
//  Copyright © 2018 maoziyue. All rights reserved.
//

#import "MZYTableCell.h"

@interface MZYTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation MZYTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDict:(NSDictionary *)dict {
    
    _dict = dict;
    
    NSString *name = dict[@"name"];
    NSString *age = dict[@"age"];
    
    self.nameLabel.text = name;
    self.descLabel.text = age;
    
}

















@end
