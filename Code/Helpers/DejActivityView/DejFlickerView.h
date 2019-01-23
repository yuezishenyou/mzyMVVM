//
//  DejFlickerView.h
//  ydx_login
//
//  Created by maoziyue on 2017/11/4.
//  Copyright © 2017年 meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>


// ----------------------------------------------------------------------------------------
// MARK: - 小提示，自动消失
// ----------------------------------------------------------------------------------------

@interface DejFlickerView : UIView


+ (DejFlickerView *)flickerWithLabeText:(NSString *)labelText;

@property (nonatomic, strong) UILabel *tipLabel;

+ (DejFlickerView *)flickerViewForView:(UIView *)addToView withLabel:(NSString *)labelText;


@end
