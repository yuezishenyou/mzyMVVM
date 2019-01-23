//
//  DejActivityView.h
//  shiwo
//
//  Created by maoziyue on 17/7/18.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <UIKit/UIKit.h>




// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------
typedef NS_ENUM(NSInteger, DejActivityStyle) {
    DejActivityStyleVertical,   //竖着 菊花上 文字下
    DejActivityStyleHorizontal, //横着 菊花左 文字右
};


@interface DejActivityView : UIView

@property (nonatomic, strong, readonly) UIView *borderView;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong, readonly) UILabel *activityLabel;

@property (nonatomic, assign) NSUInteger labelWidth;

@property (nonatomic, assign) BOOL showNetworkActivityIndicator;

@property (nonatomic, assign) DejActivityStyle dejActivityStyle;

//只显示菊花
//只显示文字
//两个都显示




+ (DejActivityView *)activityViewForView:(UIView *)addToView;

+ (DejActivityView *)activityViewWithLabel:(NSString *)labelText;

//文字＋菊花
+ (DejActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText;

//文字＋菊花
+ (DejActivityView *)activityViewForView:(UIView *)addToView withError:(NSString *)labelText;


+ (void)removeView;

+ (void)removeViewAnimated:(BOOL)animated;

@end



@interface DejActivityView ()

- (UIView *)viewForView:(UIView *)view;
- (CGRect)enclosingFrame;
- (void)setupBackground;
- (UIView *)makeBorderView;
- (UIActivityIndicatorView *)makeActivityIndicator;
- (UILabel *)makeActivityLabelWithText:(NSString *)labelText;
- (void)animateShow;
- (void)animationRemove;

@end











// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------
@interface DejActivityBezelView : DejActivityView




@end










// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------
@interface DejActivityWhiteView : DejActivityView

@end









// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------
@interface DejActivityKeyboardView : DejActivityView

@end





