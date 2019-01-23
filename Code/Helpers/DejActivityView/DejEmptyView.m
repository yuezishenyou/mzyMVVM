//
//  DejEmptyView.m
//  YDClient
//
//  Created by maoziyue on 2018/3/23.
//  Copyright © 2018年 YD. All rights reserved.
//

#import "DejEmptyView.h"
#import <QuartzCore/QuartzCore.h>

#define kNomalLoading @"正在加载"
#define kErrorLoading @"加载失败"
#define kSucceLoading @"加载成功"
#define kBorderWidth  (100) //正方形
#define kBorderHeight (50)  //长方形
#define kFontSize_17     (17)
//#define kBorderHeight (50)
#define kDuration     (1.25)

@interface DejEmptyView ()

@property (nonatomic, strong) UIView *originalView;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *activityLabel;

@end
static DejEmptyView *dejFlickerView = nil;
@implementation DejEmptyView
{
    CGFloat width;
    CGFloat height;
}



#pragma mark ------------Util----------------
- (void)setupBackground
{
    self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}
- (CGRect)enclosingFrame;
{
    return [[UIScreen mainScreen]bounds];
}

- (UIView *)makeBorderView;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.opaque = NO;
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    view.backgroundColor =  [UIColor clearColor]; //[[UIColor blackColor]colorWithAlphaComponent:0.6];  //
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
    return view;
}

- (UIActivityIndicatorView *)makeActivityIndicator
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    return indicator;
}

- (UILabel *)makeActivityLabelWithText:(NSString *)labelText;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.font = [UIFont systemFontOfSize:kFontSize_17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    //label.backgroundColor = [UIColor clearColor];
    //label.shadowColor = [UIColor whiteColor];
    //label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.text = labelText;
    
    return label;
}

- (UIView *)viewForView:(UIView *)view;
{
    return view;
}




// ----------------------------------------------------------------------------------------
// MARK: - 基础方法
// ----------------------------------------------------------------------------------------

- (void)layoutSubviews
{
    //NSLog(@"layoutSubviews:%ld",self.dejActivityStyle);
    
    /**
     * 这里要布局
     * borderView 在布局，居中
     */
    
    
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
    
    
//    NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:kFontSize_17]};
//    CGSize size = [self.activityLabel.text sizeWithAttributes:att];
    
    
    CGFloat borderWidth;
    CGFloat borderHeight;
    
    borderWidth = kBorderWidth;
    borderHeight = kBorderWidth;
    

    
    
    
    CGRect borderFrame = CGRectZero;
    borderFrame.size.width = borderWidth;
    borderFrame.size.height = borderHeight;
    self.borderView.frame = borderFrame;
    self.borderView.center = CGPointMake(width / 2 + 50 , height / 2 - 10);
    
    
    
    //activityIndicator
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);//40px
    self.activityIndicator.transform = transform;
    self.activityIndicator.color = [UIColor orangeColor];
    
    
    //activityLabel
    CGRect activityLabelFrame = CGRectZero;
    activityLabelFrame.size.width = borderWidth;
    activityLabelFrame.size.height = 20;
    self.activityLabel.frame = activityLabelFrame;
    
    
    //中间分开 菊花上移10 文字下移动20
    self.activityIndicator.center = CGPointMake(borderWidth/ 2, borderHeight/ 2 );
    self.activityLabel.center = CGPointMake(borderWidth / 2, borderHeight / 2 + 20 );
    self.activityLabel.textAlignment = NSTextAlignmentCenter;
    

    
}


- (DejEmptyView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText duration:(NSInteger)duration
{
    
    if (self = [super initWithFrame:CGRectZero])
    {

        width = [[UIScreen mainScreen]bounds].size.width;
        height = [[UIScreen mainScreen]bounds].size.height;
        
        [self setupBackground];
        
        self.originalView = addToView;
        
//        self.labelWidth = 200;
        
        self.borderView = [self makeBorderView];
        
        self.activityIndicator = [self makeActivityIndicator];
        
        self.activityLabel = [self makeActivityLabelWithText:labelText];
        
//        self.dejActivityStyle = style;
        
        [addToView addSubview:self];
        [self addSubview:self.borderView];
        [self.borderView addSubview:self.activityIndicator];
        [self.borderView addSubview:self.activityLabel];
        
        self.frame = [[UIScreen mainScreen]bounds];
        
        self.backgroundColor = [UIColor clearColor];
    
    }
    return self;
}








+ (void)removeView
{
    if (!dejFlickerView) {
        return;
    }
    
    [dejFlickerView removeFromSuperview];
    dejFlickerView = nil;
}

+ (void)removeViewAnimated:(BOOL)animated
{
    if (!dejFlickerView) {
        return;
    }
    if (animated){
        [dejFlickerView animationRemove];
    }else{
        [self removeView];
    }
}


- (void)animationRemove
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
    
    self.alpha = 0.0;
    
    [UIView commitAnimations];
    
}

- (void)removeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
{
    [[self class] removeView];
    
}

- (void)animateShow;
{
    self.alpha = 0.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.alpha = 1.0;
    
    [UIView commitAnimations];
}










+ (DejEmptyView *)flickerViewForView:(UIView *)addToView withLabel:(NSString *)labelText duration:(NSInteger)duration
{
    if (dejFlickerView)
    {
        [self removeView];
    }
    dejFlickerView = [[self alloc]initForView:addToView withLabel:labelText duration:duration];
    
    return dejFlickerView;
}









// ----------------------------------------------------------------------------------------
// MARK: - 自定义方法
// ----------------------------------------------------------------------------------------

+ (DejEmptyView *)emptyViewForView:(UIView *)addToView withText:(NSString *)text
{
    return [self flickerViewForView:addToView withLabel:text duration:kDuration];
}






+ (DejEmptyView *)flickerWithLabeText:(NSString *)labelText
{
    UIWindow *w = [UIApplication sharedApplication].keyWindow;
    return [self flickerViewForView:w withLabel:labelText duration:kDuration];
}












- (void)dealloc;
{
    if ([dejFlickerView isEqual:self])
    {
        dejFlickerView = nil;
    }
}



@end
