//
//  DejActivityView.m
//  shiwo
//
//  Created by maoziyue on 17/7/18.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "DejActivityView.h"
#import <QuartzCore/QuartzCore.h>

#define kNomalLoading @"正在加载"
#define kErrorLoading @"加载失败"
#define kSucceLoading @"加载成功"
#define kBorderWidth  (100) //正方形
#define kBorderHeight (50)  //长方形
#define kFontSize_17     (17)


@interface DejActivityView ()

@property (nonatomic, strong) UIView *originalView;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *activityLabel;


@end

static DejActivityView *dejActivityView = nil;
@implementation DejActivityView
{
    CGFloat width;
    CGFloat height;
}
@synthesize originalView;
@synthesize borderView;
@synthesize activityIndicator;
@synthesize activityLabel;
@synthesize labelWidth;
@synthesize showNetworkActivityIndicator;



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
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
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

    self.frame = [self enclosingFrame];
    
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
    
    
    NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:kFontSize_17]};
    CGSize size = [self.activityLabel.text sizeWithAttributes:att];
    
    
    CGFloat borderWidth;
    CGFloat borderHeight;
    if (self.dejActivityStyle == DejActivityStyleVertical)
    {//竖着
        borderWidth = kBorderWidth;
        borderHeight = kBorderWidth;
    }
    else
    {//横着
        borderWidth = size.width + 50 +10;
        borderHeight = kBorderHeight;
    }
    


    CGRect borderFrame = CGRectZero;
    borderFrame.size.width = borderWidth;
    borderFrame.size.height = borderHeight;
    self.borderView.frame = borderFrame;
    self.borderView.center = CGPointMake(width / 2, height /2 - 100);

    
    
    //activityIndicator
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);//40px
    self.activityIndicator.transform = transform;
    self.activityIndicator.color = [UIColor orangeColor];

    
    //activityLabel
    CGRect activityLabelFrame = CGRectZero;
    activityLabelFrame.size.width = borderWidth;
    activityLabelFrame.size.height = 20;
    self.activityLabel.frame = activityLabelFrame;
    
    
    if (self.dejActivityStyle == DejActivityStyleVertical)
    {//竖着
        //中间分开 菊花上移10 文字下移动20
        self.activityIndicator.center = CGPointMake(borderWidth/ 2, borderHeight/ 2 - 10 );
        self.activityLabel.center = CGPointMake(borderWidth / 2, borderHeight / 2 + 20 );
        self.activityLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {//横着
        //左右分开 菊花22px 文字要向右便宜45
        self.activityIndicator.center = CGPointMake(22, borderHeight / 2);
        self.activityLabel.center = CGPointMake(borderWidth / 2 + 45, borderHeight / 2 );
        self.activityLabel.textAlignment = NSTextAlignmentLeft;
    }
    

}

- (DejActivityView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)aLabelWidth style:(DejActivityStyle)style
{
    if (self = [super initWithFrame:CGRectZero])
    {
        
        //NSLog(@"-----init-------");
        width = [[UIScreen mainScreen]bounds].size.width;
        height = [[UIScreen mainScreen]bounds].size.height;
        [self setupBackground];
        
        self.originalView = addToView;
        
        self.labelWidth = aLabelWidth;
        
        self.borderView = [self makeBorderView];
        
        self.activityIndicator = [self makeActivityIndicator];
        
        self.activityLabel = [self makeActivityLabelWithText:labelText];
        
        self.dejActivityStyle = style;
        
        [addToView addSubview:self];
        [self addSubview:self.borderView];
        [self.borderView addSubview:self.activityIndicator];
        [self.borderView addSubview:self.activityLabel];
        
        //[self animateShow];//显示动画 不好看
        
    }
    return self;
}

+ (DejActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)aLabelWidth style:(DejActivityStyle)style
{
    if (dejActivityView)
    {
        [self removeView];
    }
    dejActivityView = [[self alloc]initForView:addToView withLabel:labelText width:aLabelWidth style:style];
    return dejActivityView;
}
//错误信息
+ (DejActivityView *)activityViewForView:(UIView *)addToView withError:(NSString *)errorText width:(NSUInteger)aLabelWidth style:(DejActivityStyle)style
{
    if (dejActivityView)
    {
        [self removeView];
    }
    dejActivityView = [[self alloc]initForView:addToView withLabel:errorText width:aLabelWidth style:style];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[dejActivityView class] removeViewAnimated:YES];
    });
    
    return dejActivityView;
}





+ (void)removeViewAnimated:(BOOL)animated
{
    if (!dejActivityView) {
        return;
    }
    
    if (animated)
    {
        [dejActivityView animationRemove];
    }
    else
    {
        [self removeView];
    }
    
}

+ (void)removeView
{
    if (!dejActivityView) {
        return;
    }
    
    if (dejActivityView.showNetworkActivityIndicator)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    [dejActivityView removeFromSuperview];
    dejActivityView = nil;
}
- (void)animationRemove
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
    
//    self.borderView.transform = CGAffineTransformIdentity;
//    self.borderView.transform = CGAffineTransformMakeScale(0.5, 0.5);
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
//    self.borderView.transform = CGAffineTransformMakeScale(2.0, 2.0);
//    self.borderView.transform = CGAffineTransformIdentity;
    self.alpha = 1.0;
    
    [UIView commitAnimations];
}




// ----------------------------------------------------------------------------------------
// MARK: - 自定义方法
// ----------------------------------------------------------------------------------------

+ (DejActivityView *)activityViewForView:(UIView *)addToView
{
    return [self activityViewForView:addToView withLabel:kNomalLoading width:0 style:DejActivityStyleHorizontal];
}

+ (DejActivityView *)activityViewWithLabel:(NSString *)labelText
{
    UIWindow *wd = [UIApplication sharedApplication].keyWindow;
    return [self activityViewForView:wd withLabel:labelText width:0 style:DejActivityStyleHorizontal];
}

+ (DejActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText
{
    return [self activityViewForView:addToView withLabel:labelText width:0 style:DejActivityStyleHorizontal];
}


+ (DejActivityView *)activityViewForView:(UIView *)addToView withError:(NSString *)labelText
{
    return [self activityViewForView:addToView withError:labelText width:0 style:DejActivityStyleHorizontal];
    //return [self activityViewForView:addToView withLabel:labelText width:0 style:DejActivityStyleHorizontal];
}








- (void)dealloc;
{
    if ([dejActivityView isEqual:self])
    {
        dejActivityView = nil;
    }
    
    //NSLog(@"-----deja 释放--------");
}




@end























// ----------------------------------------------------------------------------------------
// MARK: - 其它
// ----------------------------------------------------------------------------------------
@implementation DejActivityBezelView

- (void)setupBackground
{
    [super setupBackground];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}


@end







// ----------------------------------------------------------------------------------------
// MARK: - 有待拓展
// ----------------------------------------------------------------------------------------

@implementation DejActivityWhiteView



@end










@implementation DejActivityKeyboardView



@end
























