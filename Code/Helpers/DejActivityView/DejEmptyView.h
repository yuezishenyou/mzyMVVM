//
//  DejEmptyView.h
//  YDClient
//
//  Created by maoziyue on 2018/3/23.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DejEmptyView : UIView

@property (nonatomic, strong) UILabel *tipLabel;

/**
 * 专为更多设计
 */

+ (DejEmptyView *)emptyViewForView:(UIView *)addToView withText:(NSString *)text;

+ (void)removeView;

@end
